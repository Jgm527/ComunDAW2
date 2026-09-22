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
set UNIDAD=Z

echo.
echo  Carpeta comun DAW2 - instalador
echo  Recurso : %RECURSO%   Unidad : %UNIDAD%:
echo.

REM ---------- 0) Limpieza ----------
echo [0/3] Limpiando mapeos y credenciales anteriores...
net use %UNIDAD%: /delete >nul 2>&1
cmdkey /delete:%SERVER% >nul 2>&1

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
echo                 cmdkey /delete:%SERVER%
echo                 del "%INICIO%\Carpeta comun DAW2.cmd"
echo.
pause
