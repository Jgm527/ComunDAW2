# 📁 Carpeta común DAW2

Este programa permite conectar el ordenador a la **carpeta común de DAW2** del servidor del aula.

Una vez instalado, podrás acceder a la carpeta compartida igual que a cualquier otra carpeta de tu ordenador.

La instalación solo hay que hacerla **una vez por ordenador**.

---

## 📋 Requisitos

Antes de empezar:

* El ordenador debe estar conectado a la **red del aula**.
* El servidor debe estar encendido.
* Necesitas permisos de administrador en el ordenador.
* Descarga el instalador correspondiente a tu sistema operativo.

Hay dos instaladores:

| Sistema    | Archivo                  |
| ---------- | ------------------------ |
| 🪟 Windows | `instalar_COMUNDAW2.bat` |
| 🐧 Linux   | `instalar_COMUNDAW2.sh`  |

> ⚠️ **No ejecutes el instalador de otro sistema operativo.**

---

# 🪟 Windows

## 1. Descargar el instalador

Descarga el archivo:

**`instalar_COMUNDAW2.bat`**

Guárdalo, por ejemplo, en el Escritorio.

---

## 2. Ejecutar como administrador

Este paso es importante.

1. Busca `instalar_COMUNDAW2.bat`.
2. Haz **clic derecho** sobre el archivo.
3. Pulsa **"Ejecutar como administrador"**.
4. Si Windows pregunta:

   > "¿Quieres permitir que esta aplicación haga cambios en el dispositivo?"

   Pulsa **"Sí"**.

Se abrirá una ventana negra y comenzará la instalación automáticamente.

---

## 3. Esperar a que termine

El instalador hará todo lo necesario automáticamente:

* Configurar el acceso a la carpeta compartida.
* Guardar las credenciales necesarias.
* Crear la unidad de red.
* Configurar la conexión para que vuelva a funcionar al iniciar Windows.

Al terminar debería aparecer un mensaje parecido a:

```text
LISTO. Unidad Z: montada y re-conectable en cada inicio.
```

Puedes pulsar una tecla para cerrar la ventana.

---

## 4. ¿Dónde está la carpeta?

Después de instalarla, abre el **Explorador de archivos** de Windows.

En **"Este equipo"** debería aparecer una nueva unidad:

**📁 Z:**

Dentro encontrarás la carpeta común de DAW2.

También puedes acceder directamente escribiendo esto en la barra de direcciones del Explorador:

```text
\\192.168.2.21\comunDAW2
```

---

## ❗ Si Windows muestra un error

### "No se puede conectar con la carpeta"

Comprueba primero que:

1. Estás conectado a la red del aula.
2. El servidor está encendido.
3. Has ejecutado el instalador **como administrador**.

Si sigue sin funcionar, no cambies ninguna configuración de Windows por tu cuenta y avisa o toquetea bajo tu propio riesgo.

---

# 🐧 Linux

## 1. Descargar el instalador

Descarga el archivo:

**`instalar_COMUNDAW2.sh`**

Puedes guardarlo en la carpeta **Descargas**.

---

## 2. Abrir un terminal

Abre la aplicación **Terminal** de Linux.

Normalmente puedes encontrarla buscando:

**Terminal**

en el menú de aplicaciones.

---

## 3. Ir a la carpeta donde está el instalador

Si lo has descargado en **Descargas**, escribe:

```bash
cd ~/Descargas
```

y pulsa **Enter**.

---


## 4. Ejecutar el instalador

Ahora escribe:

```bash
sudo ./instalar_COMUNDAW2.sh
```

y pulsa **Enter**.

Linux te pedirá tu contraseña.

> 🔒 Cuando escribas la contraseña **no aparecerán letras ni asteriscos en pantalla**. Es normal. Escríbela igualmente y pulsa Enter.

---

## 5. Esperar a que termine

El instalador hará automáticamente todo lo necesario:

* Instalar el soporte necesario para acceder a carpetas compartidas.
* Crear la carpeta de conexión.
* Configurar la conexión con el servidor.
* Configurar la conexión automática al encender el ordenador.
* Añadir `comunDAW2` a la barra lateral del explorador de archivos.

Al final debería aparecer:

```text
======================================
 Instalación completada
======================================
```

Si aparece ese mensaje, la instalación ha terminado correctamente.

---

# 📂 ¿Dónde está la carpeta en Linux?

Abre la aplicación **Archivos**.

En la barra lateral del explorador de archivos debería aparecer:

**📁 comunDAW2**

Haz clic ahí para abrir la carpeta compartida.

También puedes encontrarla directamente en:

```text
/mnt/comunDAW2
```

---

# 🔄 ¿Tengo que ejecutar el instalador cada vez?

**No.**

El instalador está pensado para ejecutarse **una sola vez por ordenador**.

Después de instalarlo:

* 🪟 Windows → la unidad **Z:** se volverá a conectar automáticamente.
* 🐧 Linux → `comunDAW2` se montará automáticamente al iniciar el ordenador.

Por tanto, **no vuelvas a ejecutar el instalador cada vez que enciendas el ordenador**.

---

# 💾 ¿Qué puedo hacer con la carpeta?

Puedes utilizar `comunDAW2` como una carpeta normal.

Por ejemplo:

* Crear carpetas.
* Crear documentos.
* Copiar archivos.
* Abrir archivos.
* Editar archivos.
* Compartir archivos con otros compañeros.

Ten en cuenta que **todo lo que guardes ahí está en la carpeta común**, por lo que los demás usuarios que tengan acceso podrán verlo.

---

# ⚠️ Importante

### No borres ni modifiques estos archivos

En Linux, no borres ni modifiques archivos del sistema relacionados con la instalación.

En Windows, no elimines la configuración de la unidad de red si quieres que siga conectándose automáticamente.

### No guardes información privada

La carpeta es **compartida entre los usuarios del aula**.

No guardes ahí:

* Contraseñas.
* Documentos personales.
* Información privada.
* Archivos que no quieras que otros usuarios puedan ver o modificar.

---

# 🆘 Si deja de funcionar

Antes de pedir ayuda, comprueba:

### 1. ¿Estás conectado a la red del aula?

La conexión al servidor solo funciona si el ordenador puede comunicarse con él.

### 2. ¿El servidor está encendido?

Si el servidor está apagado, la carpeta no estará disponible.

### 3. ¿Puedes acceder a Internet?

Aunque Internet funcione, eso no garantiza que el servidor del aula sea accesible, pero sirve como primera comprobación de la conexión.

### 4. Reinicia el ordenador

En muchos casos, reiniciar permite que la conexión automática vuelva a establecerse correctamente.

Si después de todo esto sigue sin funcionar, informa al profesor indicando:

* Sistema operativo: **Windows / Linux**
* Qué estabas intentando hacer.
* Qué mensaje de error aparece.
* Si la carpeta aparece o no.

---

## ✅ Resumen rápido

### Windows

```text
1. Descargar instalar_COMUNDAW2.bat
2. Clic derecho → Ejecutar como administrador
3. Pulsar "Sí"
4. Esperar a que termine
5. Abrir "Este equipo"
6. Entrar en Z:
```

### Linux

```text
1. Descargar instalar_COMUNDAW2.sh
2. Abrir Terminal
3. cd ~/Descargas
4. chmod +x instalar_COMUNDAW2.sh
5. sudo ./instalar_COMUNDAW2.sh
6. Escribir la contraseña
7. Abrir "Archivos"
8. Entrar en comunDAW2
```

**Una vez instalado, no es necesario repetir el proceso.**
