@echo off

REM Change directory to your Minecraft mods repository
cd C:/Minecraft/mods

REM Check if there are any uncommitted changes
git diff-index --quiet HEAD --
if errorlevel 1 (
    REM If there are uncommitted changes, stash them
    git stash push -u --quiet
)

REM Pull changes from the remote main branch
git pull origin main --quiet

REM Check if there are any conflicts
git ls-files -u >nul
if errorlevel 1 (
    REM Apply the top stash if there were any
    git stash pop --quiet

    REM Drop any stashed changes if they were applied successfully
    if not errorlevel 1 (
        git stash drop --quiet
    )

    echo Changes pulled and applied successfully.
) else (
    REM Notify the user of conflicts and prompt them to resolve them manually
    echo Merge conflicts detected. Please resolve them manually.
)

pause
