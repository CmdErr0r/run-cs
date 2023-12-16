@echo off
setlocal enabledelayedexpansion
echo be careful for there is not have 2 same Diconary Name

set /P dic="[Path & Directory Name]> "

set "length=0"
set "word=!dic![EOF]"
set "parser=-1"

:loop
    if "!word:~%length%,5!"=="[EOF]" (
        set /a length-=!parser!
        
        if "!parser!" == "-1" (
            set "key=!dic!"
        ) else (
            set "key=!dic:~%parser%,%length%!"
        )
        
        goto eof
    )

    if "!word:~%length%,1!"=="\" set /a "parser=%length%+1"

    set /a length+=1
goto loop
:eof

set /P template="[Template Name] (!key!)> "
if "!template!"=="" set "template=!key!"

set /p "continue=Continue? [Y/n]> "
echo !continue!

if "!continue!" == "n" (
    exit /b
) else if "!continue!" == "N" (
    exit /b
)

mkdir "!dic!"
cd "!dic!"

dotnet new sln -n "run"
dotnet new console -n "!template!"
dotnet new classlib -n "Library"

dotnet sln "./run.sln" add "!template!/!template!.csproj"
dotnet sln "./run.sln" add "Library/Library.csproj"

dotnet add "!template!/!template!.csproj" reference "Library/Library.csproj"

echo "cd !dic!"
echo "dotnet run"

code .

timeout /t 1 /nobreak >nul 2>null
