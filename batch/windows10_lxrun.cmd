@echo off
:repeat
start /wait lxrun /install /y
if %errorlevel% equ 0 goto done
if %errorlevel% equ -1 goto repeat
:done
echo " install done "