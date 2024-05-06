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

REM Check if the pull operation was successful
if %errorlevel% neq 0 (
    REM If the pull operation failed, notify the user
    echo Failed to pull changes from the remote main branch. Please check your network connection and try again.
) else (
    REM Apply the top stash if there were any
    git stash pop --quiet

    REM Drop any stashed changes if they were applied successfully
    if not errorlevel 1 (
        git stash drop --quiet
    )

    echo Changes pulled and applied successfully.
)
