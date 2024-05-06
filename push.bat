@echo off
REM Change directory to your Minecraft mods repository
cd C:/Minecraft/mods

REM Ask for confirmation before proceeding
echo.
echo *************************************************************************
echo !!  WARNING  !!!!!!!!!!!!!!!!    WARNING    !!!!!!!!!!!!!!!!  WARNING  !!
echo *************************************************************************
echo.
echo               YOU ARE ABOUT TO MAKE CHANGES TO THE CLOUD!              
echo           Please make sure this is what you are trying to do.
echo.
echo.

set /P confirm="Do you wish to continue? (Y/n): "

if /I "%confirm%"=="y" (
    echo So be it.
    timeout /t 2 /nobreak >nul
    
) else if /I "%confirm%"=="yes" (
    echo So be it.
    timeout /t 2 /nobreak >nul
    
) else (
    echo Great choice, it's always good to double check.
    exit /b
    
)

REM Check for uncommitted changes
git diff-index --quiet HEAD --
if errorlevel 1 (
    echo Uncommitted changes detected.

    REM Stash changes if they haven't been stashed
    git stash -u --quiet

    REM Fetch the latest changes from the remote repository
    git fetch origin --quiet

    REM Create and switch to a new branch
    FOR /F "tokens=*" %%i IN ('date /T') DO SET thedate=%%i
    FOR /F "tokens=*" %%i IN ('time /T') DO SET thetime=%%i
    SET new_branch=update-%thedate%-%thetime%
    SET new_branch=%new_branch::=-%
    SET new_branch=%new_branch:/=-%
    SET new_branch=%new_branch: =%
    git checkout -b %new_branch% --quiet

    REM Apply stashed changes
    git stash pop --quiet

    REM Add all changes and commit
    git add .
    git commit -m "(Mods Updated by Push-Script) %date% %time%" --quiet

    REM Push the new branch
    git push origin %new_branch% --quiet

    REM Attempt to merge new_branch into main
    git checkout main --quiet
    git pull origin main --quiet
    git merge %new_branch% --no-commit --no-ff --quiet

    git ls-files -u > nul
    if errorlevel 1 (
        echo Merge conflicts detected. Please resolve manually.
        REM Windows alert
        powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('There was a problem merging the mods due to a conflict in files. If you are not familiar with resolving merge conflicts, please contact the Server Owner to resolve this problem.', 'Merge Conflict')"
        git merge --abort --quiet
    ) else (
        git commit -m "Merged updates from %new_branch%" --quiet
        git push origin main --quiet
        echo Mods updated and merged successfully.
    )

    REM Clean up - go back to the main branch either way
    git checkout main --quiet
    
    echo The script is done, BUT..
    echo - - - The server won't update until it restarts. - - -
    echo.
    echo Ask Melanie to restart the server for the new mods to take effect.
    echo Of course, you could play single player while you're waiting.
    echo.
    echo.
    echo Have an amazing day, you amazing person!
        
) else (
    echo.
    echo No changes detected
    echo The cloud files were not changed.
    echo.
    echo.
)

pause
