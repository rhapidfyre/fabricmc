@echo off
REM Change directory to your Minecraft mods repository
cd C:/Minecraft/mods

net session >nul 2>&1
if %errorlevel% == 0 (
	echo Running with administrator privileges. Skipping confirmations.
) else (
	echo *************************************************************************
	echo !!!!!!!!!!!!!!!!!!!!!!!!!!!    WARNING    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	echo !!            YOU ARE ABOUT TO MAKE CHANGES TO THE CLOUD!              !!
	echo *************************************************************************
	echo If you continue, you will change all of the mods on everyone's computers!
	echo           Please make sure this is what you are trying to do.
	echo *************************************************************************
	pause
)

REM Ask for confirmation before proceeding
set /P confirm="You are changing the mods on our minecraft server. Type 'GO' to proceed."
if /I "%confirm%" NEQ "GO" (
    echo Great choice, it's always good to double check.
	pause
    exit /b
)

REM Check for uncommitted changes
git diff-index --quiet HEAD --
if errorlevel 1 (
    echo Uncommitted changes detected.

    REM Stash changes if they haven't been stashed
    git stash -u

    REM Fetch the latest changes from the remote repository
    git fetch origin

    REM Create and switch to a new branch
    FOR /F "tokens=*" %%i IN ('date /T') DO SET thedate=%%i
    FOR /F "tokens=*" %%i IN ('time /T') DO SET thetime=%%i
    SET new_branch=update-%thedate%-%thetime%
    SET new_branch=%new_branch::=-%
    SET new_branch=%new_branch:/=-%
    SET new_branch=%new_branch: =%
    git checkout -b %new_branch%

    REM Apply stashed changes
    git stash pop

    REM Add all changes and commit
    git add .
    git commit -m "(Mods Updated by Push-Script) %date% %time%"

    REM Push the new branch
    git push origin %new_branch%

    REM Attempt to merge new_branch into main
    git checkout main
    git pull origin main
    git merge %new_branch% --no-commit --no-ff

    git ls-files -u > nul
    if errorlevel 1 (
        echo Merge conflicts detected. Please resolve manually.
        REM Windows alert
        powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('There was a problem merging the mods due to a conflict in files. If you are not familiar with resolving merge conflicts, please contact the Server Owner to resolve this problem.', 'Merge Conflict')"
        git merge --abort
    ) else (
        git commit -m "Merged updates from %new_branch%"
        git push origin main
        echo Mods updated and merged successfully.
    )

    REM Clean up - go back to the main branch either way
    git checkout main
) else (
    echo No changes detected. The cloud files were not changed.
	echo You may close this script.
)
pause
