@echo off

REM Change directory to your Minecraft mods repository
cd C:/Minecraft/fabricmc
set stash_created=0

REM Stash any uncommitted changes and record if a stash was created
git diff-index --quiet HEAD --
if errorlevel 1 (
    git stash push -u >nul 2>&1
    set stash_created=1
)

REM Pull changes from the remote main branch
git pull origin main >nul 2>&1

REM Output result of the pull operation and alert the user
if %errorlevel% neq 0 (
	echo Failed to pull changes from main:origin (fabricmc)
) else (
    echo Successfully Updated from main:origin (fabricmc)
)

REM Only alert the user if there are issues applying the stash
if %stash_created% == 1 (
    git stash pop >nul 2>&1
    if errorlevel 1 (
		echo Failed to restore pre-update changes.
    ) else (
        echo Pre-update changes restored successfully.
    )
)