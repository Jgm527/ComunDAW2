@echo off
setlocal EnableDelayedExpansion
title Carpeta comun DAW2 - instalador FINAL

REM ==============================================================
REM  Instalador del recurso comun del aula
REM  Ejecutar UNA vez por PC, COMO ADMINISTRADOR.
REM  FORZA NTLM contra la cuenta LOCAL del server para esquivar el
REM  Kerberos del dominio (error 1311). No tocar el prefijo .\ .
REM ==============================================================

set COMPARTIDA=comunDAW2
set PASSWORD=renaido
set SERVER=192.168.2.21
set RECURSO=\\%SERVER%\comunDAW2
set UNIDAD=W

echo.
echo  Carpeta comun DAW2 - instalador
echo  Recurso : %RECURSO%   Unidad : %UNIDAD%:
echo.

REM ---------- 0) Comprobar mapeos anteriores ----------
echo [0/3] Comprobando mapeos anteriores...
powershell -NoProfile -Command "if (-not (Get-Command Get-SmbMapping -ErrorAction SilentlyContinue)) { exit 3 }; try { $m = @(Get-SmbMapping -ErrorAction Stop | Where-Object { $_.LocalPath -ieq '%UNIDAD%:' }) } catch { exit 3 }; if ($m.Count -eq 0) { exit 1 }; if ($m[0].RemotePath -ieq '%RECURSO%') { exit 0 }; exit 2"
if errorlevel 3 (
    echo   [ERROR] No se pudo comprobar la unidad %UNIDAD%:. No se modifico ninguna unidad.
    pause
    exit /b 1
)
if errorlevel 2 (
    echo   [ERROR] %UNIDAD%: ya esta asignada a otro recurso. No se modifico.
    pause
    exit /b 1
)
if not errorlevel 1 (
    echo   [INFO] Actualizando el mapeo anterior de %UNIDAD%:...
    net use %UNIDAD%: /delete /y >nul 2>&1
    if errorlevel 1 (
        echo   [ERROR] No se pudo retirar el mapeo anterior de %UNIDAD%:.
        pause
        exit /b 1
    )
)

REM La version anterior usaba Z:. Solo se retira si apunta exactamente
REM a este recurso; una unidad Z: del dominio u otro recurso queda intacta.
powershell -NoProfile -Command "if (-not (Get-Command Get-SmbMapping -ErrorAction SilentlyContinue)) { exit 3 }; try { $m = @(Get-SmbMapping -ErrorAction Stop | Where-Object { $_.LocalPath -ieq 'Z:' }) } catch { exit 3 }; if ($m.Count -eq 0) { exit 1 }; if ($m[0].RemotePath -ieq '%RECURSO%') { exit 0 }; exit 2"
if errorlevel 3 (
    echo   [AVISO] No se pudo comprobar Z:. Se deja intacta.
) else if not errorlevel 1 (
    echo   [INFO] Z: apunta a la instalacion anterior de comunDAW2; retirandola...
    net use Z: /delete /y >nul 2>&1
    if errorlevel 1 (
        echo   [ERROR] No se pudo retirar la instalacion anterior de Z:.
        pause
        exit /b 1
    )
) else (
    echo   [INFO] Z: no corresponde a comunDAW2; se deja intacta.
)

REM ---------- 1) Credencial cifrada ----------
echo [1/3] Guardando credencial de %COMPARTIDA%...
cmdkey /add:%SERVER% /user:%COMPARTIDA% /pass:%PASSWORD%
if errorlevel 1 (
    echo   [ERROR] cmdkey fallo. Ejecuta como Administrador.
    pause
    exit /b 1
)
echo   [OK] Credencial guardada.

REM ---------- 2) Montar unidad. El .\ del user es OBLIGATORIO ----------
echo [2/3] Montando %UNIDAD%: como persistente...
net use %UNIDAD%: %RECURSO% /user:.\%COMPARTIDA% %PASSWORD% /persistent:yes
if errorlevel 1 (
    echo   [ERROR] No se pudo montar %UNIDAD%: [%errorlevel%].
    echo   - 1311 = el net use NO lleva el prefijo .\  en el usuario.
    echo   - Comprueba acceso al puerto 445: Test-NetConnection 192.168.2.21 -Port 445
    pause
    exit /b 1
)
echo   [OK] Unidad %UNIDAD%: montada.

REM ---------- 3) Acceso directo en Inicio ----------
echo [3/3] Creando acceso directo de inicio...
set INICIO=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp
> "%INICIO%\Carpeta comun DAW2.cmd" (
    echo @echo off
    echo net use %UNIDAD%: %RECURSO% /user:.\%COMPARTIDA% %PASSWORD% /persistent:yes ^>nul 2^>^&1
    echo start %RECURSO%\ 
    echo exit
)
if exist "%INICIO%\Carpeta comun DAW2.cmd" (
    echo   [OK] Acceso directo creado en Inicio de todos los usuarios.
) else (
    echo   [AVISO] No se creo. Ejecuta como Administrador.
)

echo.
echo  LISTO. Unidad %UNIDAD%: montada y re-conectable en cada inicio.
echo  Para deshacer: net use %UNIDAD%: /delete
echo                 del "%INICIO%\Carpeta comun DAW2.cmd"
echo.
pause
