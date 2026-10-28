# Carpeta común DAW2

Estos instaladores conectan el ordenador a la carpeta compartida `comunDAW2` del servidor del aula (`192.168.2.21`).

| Sistema | Instalador | Acceso |
|---|---|---|
| Windows | `instalar_comunDAW2.bat` | Unidad `W:` |
| Linux | `instalar_COMUNDAW2.sh` | `/mnt/comunDAW2` |

No ejecutes el instalador de otro sistema operativo.

## Requisitos

- Estar conectado a la red del aula.
- Que el servidor esté encendido.
- Tener permisos de administrador en Windows o poder usar `sudo` en Linux.

## Windows

1. Descarga `instalar_comunDAW2.bat`.
2. Haz clic derecho en el archivo y selecciona **Ejecutar como administrador**.
3. Acepta el aviso de Windows y espera a que termine.
4. Abre el Explorador de archivos y entra en **Este equipo > W:**.

También puedes abrir el recurso directamente desde el Explorador:

```text
\\192.168.2.21\comunDAW2
```

El instalador guarda las credenciales necesarias, conecta `W:` y configura la reconexión al iniciar Windows. Si `W:` ya está asignada a este mismo recurso, actualiza esa conexión; si está ocupada por otro recurso, se detiene sin modificarla.

### Instalaciones anteriores y unidad Z:

Una versión anterior del instalador podía asignar `comunDAW2` a `Z:`. Al actualizar, el instalador comprueba a qué recurso apunta `Z:` y solo la retira si coincide exactamente con `\\192.168.2.21\comunDAW2`. Si `Z:` corresponde a otra carpeta compartida —incluida una unidad asignada por el dominio—, la deja intacta. La nueva instalación utiliza `W:`.

Si Windows no puede comprobar la asignación antigua de `Z:`, la deja intacta y continúa. Si no puede comprobar `W:`, se detiene para evitar modificar una unidad ajena.

Windows puede impedir dos conexiones al mismo servidor con credenciales distintas (error 1219). El instalador no desconecta recursos ajenos para intentar resolverlo. Si aparece ese error al iniciar sesión en el dominio, el administrador tendrá que proporcionar un nombre de servidor alternativo para `comunDAW2` o configurar credenciales compatibles.

## Linux

1. Descarga `instalar_COMUNDAW2.sh`.
2. Abre un terminal y ve a la carpeta donde lo guardaste. Por ejemplo:

   ```bash
   cd ~/Descargas
   ```

3. Dale permiso de ejecución y ejecútalo:

   ```bash
   chmod +x instalar_COMUNDAW2.sh
   sudo ./instalar_COMUNDAW2.sh
   ```

4. Escribe tu contraseña cuando la solicite. Mientras la escribes no aparecerán letras ni asteriscos; es normal.
5. Espera al mensaje **Instalación completada**.

La carpeta estará disponible en `/mnt/comunDAW2` y aparecerá en la barra lateral de Archivos. El instalador configura un servicio para montarla automáticamente al iniciar el ordenador. En Linux se usa un punto de montaje; no se asigna ni se modifica ninguna letra de unidad como `Z:`.

## Volver a ejecutar el instalador

No es necesario ejecutarlo cada vez que enciendas el ordenador. Si necesitas reparar o actualizar la instalación, puedes volver a ejecutar el instalador del sistema correspondiente:

- **Windows:** conserva `W:` si ya apunta a `comunDAW2`, actualiza la conexión y el acceso de inicio; solo elimina la antigua asignación `Z:` si apunta exactamente a este recurso. No elimina unidades que apunten a otras carpetas.
- **Linux:** vuelve a configurar el mismo servicio, punto de montaje y marcador de Archivos, evitando duplicar el marcador.

## Si no funciona

Comprueba que estás conectado a la red del aula y que el servidor está encendido. En Windows, ejecuta el instalador como administrador. En Linux, reinicia el ordenador para que el servicio vuelva a intentar la conexión.

Si el problema continúa, informa al profesor del sistema operativo, de lo que estabas intentando hacer y del mensaje de error. No cambies por tu cuenta las unidades o configuraciones del dominio.

## Uso de la carpeta compartida

Puedes crear, copiar, abrir y editar archivos en `comunDAW2`. El contenido es compartido con otros usuarios del aula: no guardes contraseñas, documentos personales ni información privada, y no borres archivos que necesiten otras personas.
