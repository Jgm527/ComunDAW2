#!/bin/bash

SERVIDOR="//192.168.2.21/comunDAW2"
IP_SERVIDOR="192.168.2.21"
PUNTO="/mnt/comunDAW2"
USUARIO="comunDAW2"
CONTRASENA="renaido"

# Usuario real que ejecutó sudo
USUARIO_LOCAL="${SUDO_USER:-$USER}"
HOME_LOCAL=$(eval echo "~$USUARIO_LOCAL")

# UID y GID del usuario local
UID_LOCAL=$(id -u "$USUARIO_LOCAL")
GID_LOCAL=$(id -g "$USUARIO_LOCAL")

echo "======================================"
echo " Instalador de comunDAW2"
echo "======================================"
echo

# --------------------------------------
# 1. Instalar soporte CIFS
# --------------------------------------

echo "Instalando soporte CIFS..."

apt install -y cifs-utils

MOUNT_CIFS=$(command -v mount.cifs)

if [ -z "$MOUNT_CIFS" ]; then
    echo "ERROR: No se encontró mount.cifs"
    exit 1
fi

echo "mount.cifs encontrado en: $MOUNT_CIFS"
echo

# --------------------------------------
# 2. Crear punto de montaje
# --------------------------------------

mkdir -p "$PUNTO"

# --------------------------------------
# 3. Crear script de montaje
# --------------------------------------

cat > /usr/local/bin/montar_COMUNDAW2.sh <<EOF
#!/bin/bash

SERVIDOR="$SERVIDOR"
IP_SERVIDOR="$IP_SERVIDOR"
PUNTO="$PUNTO"

# Esperar a que el servidor tenga conectividad
for i in {1..30}; do
    if ping -c 1 -W 1 "\$IP_SERVIDOR" >/dev/null 2>&1; then
        break
    fi

    sleep 2
done

# Si ya está montado, terminar correctamente
if mountpoint -q "\$PUNTO"; then
    exit 0
fi

# Intentar montar
exec "$MOUNT_CIFS" "\$SERVIDOR" "\$PUNTO" \
-o "username=$USUARIO,password=$CONTRASENA,vers=3.0,uid=$UID_LOCAL,gid=$GID_LOCAL,file_mode=0664,dir_mode=0775"
EOF

chmod 755 /usr/local/bin/montar_COMUNDAW2.sh

# --------------------------------------
# 4. Crear servicio systemd
# --------------------------------------

cat > /etc/systemd/system/comunDAW2.service <<EOF
[Unit]
Description=Montar carpeta compartida DAW2
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/montar_COMUNDAW2.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

# --------------------------------------
# 5. Activar servicio
# --------------------------------------

echo "Configurando servicio..."

systemctl daemon-reload
systemctl enable comunDAW2.service
systemctl reset-failed comunDAW2.service

# --------------------------------------
# 6. Montar ahora
# --------------------------------------

echo "Comprobando montaje..."

if mountpoint -q "$PUNTO"; then
    echo "La carpeta ya estaba montada."
else
    echo "Montando $SERVIDOR..."

    systemctl start comunDAW2.service

    if ! mountpoint -q "$PUNTO"; then
        echo
        echo "ERROR: No se pudo montar $PUNTO"
        systemctl status comunDAW2.service --no-pager
        exit 1
    fi
fi

echo "Montaje correcto."
echo

# --------------------------------------
# 7. Configurar barra lateral de Archivos
# --------------------------------------

echo "Configurando barra lateral..."

BOOKMARKS_GTK3="$HOME_LOCAL/.config/gtk-3.0/bookmarks"
BOOKMARKS_GTK4="$HOME_LOCAL/.config/gtk-4.0/bookmarks"

mkdir -p "$(dirname "$BOOKMARKS_GTK3")"
mkdir -p "$(dirname "$BOOKMARKS_GTK4")"

touch "$BOOKMARKS_GTK3"
touch "$BOOKMARKS_GTK4"

# Eliminar entradas anteriores
sed -i '/comunDAW2/d' "$BOOKMARKS_GTK3"
sed -i '\#/mnt/comunDAW2#d' "$BOOKMARKS_GTK3"

sed -i '/comunDAW2/d' "$BOOKMARKS_GTK4"
sed -i '\#/mnt/comunDAW2#d' "$BOOKMARKS_GTK4"

# Añadir marcador
printf '%s %s\n' "file:///mnt/comunDAW2" "comunDAW2" >> "$BOOKMARKS_GTK3"
printf '%s %s\n' "file:///mnt/comunDAW2" "comunDAW2" >> "$BOOKMARKS_GTK4"

# Asegurar propietario
chown "$USUARIO_LOCAL:$USUARIO_LOCAL" "$BOOKMARKS_GTK3"
chown "$USUARIO_LOCAL:$USUARIO_LOCAL" "$BOOKMARKS_GTK4"

# --------------------------------------
# 8. Eliminar antiguo enlace de Home
# --------------------------------------

ENLACE="$HOME_LOCAL/comunDAW2"

if [ -L "$ENLACE" ]; then
    rm "$ENLACE"
fi

# --------------------------------------
# 9. Actualizar Archivos
# --------------------------------------

if command -v nautilus >/dev/null 2>&1; then
    sudo -u "$USUARIO_LOCAL" nautilus -q 2>/dev/null || true
fi

# --------------------------------------
# 10. Comprobación final
# --------------------------------------

echo
echo "======================================"
echo " Instalación completada"
echo "======================================"
echo
echo "Servidor: $SERVIDOR"
echo "Montaje:  $PUNTO"
echo "Usuario:  $USUARIO_LOCAL"
echo "UID:      $UID_LOCAL"
echo "GID:      $GID_LOCAL"
echo
echo "Permisos configurados:"
echo "  Directorios: 0775"
echo "  Archivos:    0664"
echo
echo "El montaje se realizará automáticamente"
echo "al arrancar el ordenador y esperará a"
echo "que haya conexión con el servidor."
echo
echo "comunDAW2 aparecerá en la barra lateral"
echo "de Archivos."
echo
echo "Contenido:"
ls "$PUNTO"
echo
