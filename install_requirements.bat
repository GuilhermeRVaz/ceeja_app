@echo off
REM Script para instalar dependências do projeto (backend)
REM Execute este arquivo a partir da raiz do projeto: c:\Users\e497976a\Desktop\python\appceeja

SET REQ_PATH=ceeja_app\backend\requirements.txt

REM Ativa venv se existir
IF EXIST ".venv\Scripts\activate" (
  call .venv\Scripts\activate
) ELSE IF EXIST "venv\Scripts\activate" (
  call venv\Scripts\activate
)

echo Instalando dependências de %REQ_PATH% ...
pip install -r "%REQ_PATH%"
IF ERRORLEVEL 1 (
  echo Erro na instalação de dependencias.
  pause
  exit /b 1
)
echo Concluído.
pause
