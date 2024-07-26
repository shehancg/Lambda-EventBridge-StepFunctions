@echo off
REM Navigate to the project root
cd %~dp0

rem Define variables
set PACKAGE_DIR=package_one
set ZIP_FILE=function_one.zip
set REQUIREMENTS_FILE=requirements.txt
set LAMBDA_FUNCTION_FILE=lambda_token_gen.py
set ENV_FILE=lambda_token_generation\.env

rem Clean up previous builds
if exist %PACKAGE_DIR% rd /s /q %PACKAGE_DIR%
if exist %ZIP_FILE% del %ZIP_FILE%

rem Create package directory
mkdir %PACKAGE_DIR%

rem Install dependencies into package directory
pip install -r %REQUIREMENTS_FILE% -t %PACKAGE_DIR%

rem Copy Lambda function code and .env file into package directory
copy %LAMBDA_FUNCTION_FILE% %PACKAGE_DIR%
copy .env %PACKAGE_DIR%\

rem Create zip file from package directory contents
cd %PACKAGE_DIR%
powershell -command "& { Compress-Archive -Path .\* -DestinationPath ..\%ZIP_FILE% }"
cd ..

rem Output the result
echo Created %ZIP_FILE% with the following contents:
powershell -command "& { Expand-Archive -Path %ZIP_FILE% -DestinationPath temp_extract }"
powershell -command "& { Get-ChildItem -Path temp_extract -Recurse }"
rd /s /q temp_extract

endlocal