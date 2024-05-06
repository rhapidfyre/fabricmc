This repository contains everything you need to get your Fabric MC in sync with the server.

You do NOT need to do any of these steps if you want to update your mods manually, or if you want to have different mods to play on another server or by yourself.

I have also provided some starting shader packs, and the server's config files.



STEPS TO AUTOMATE UPDATES & SYNCHRONIZE:

1) Clone this repository to "C:/Minecraft/fabricmc".
	1A) If you have already cloned it somewhere else, just move the "fabricmc" folder to "C:/Minecraft"
	2B) If "C:/Minecraft" doesn't exist, create it.

2) Search for app "Task Scheduler", and open it.

3) In Task Scheduler:
	A) On the right hand side, click "Create Task"
	B) In the new popup, name the task something like "Fabric MC"
	C) At the bottom, set "Run whether user is logged on or not".
	D) Go to the "TRIGGERS" tab at the top
	E) Click "New..." at the bottom of the "TRIGGERS" section
	F) Set the following options:
		On a Schedule
		One Time
		Start: (today's date) (any time before now), uncheck "Synchronize"
		Uncheck Delay Task
		Check Repeat Task, and set it to 1 hour (or less), duration INDEFINITELY
			Leave "stop all running tasks" unchecked.
		Uncheck Stop Task
		Uncheck Expire
		Check Enabled
	G) Click OK, then go to the "ACTIONS" tab at the top.
	H) Click "New..." at the bottom of the "ACTIONS" section
	I) Set the following options:
		Start a Program
		C:/Minecraft/fabricmc/pull.bat
		Leave "arguments" and "start in" blank
	J) Click OK, then go to "CONDITIONS" tab at the top.
	K) Uncheck everything in the "CONDITIONS" tab
	L) Go to "SETTINGS" tab at the top
	M) Check:
		Allow task to be run on demand
		Run task as soon as possible after a scheduled start is missed
		If the running task does not end when requested, force it to stop
	N) Set the dropdown menu to "Do not start a new instance".
	O) Hit "OK" and enter your Windows/Microsoft account password.
	P) Close the Task Scheduler

NEXT-
4) Download Fabric MC from https://fabricmc.net/use/installer/
5) Run the Fabric MC installer downloaded from https://fabricmc.net/use/installer/
	A) Ensure you set the version to "1.20.4"
	B) Loader Version: "0.15.11"
	C) Launcher Location: Set this to your ".minecraft" folder, which is usually:
		C:\Users\<your_username>\AppData\Roaming\.minecraft
	D) Click "Install"

****
****	!! STOP !!
** IF YOU WANT TO PLAY SINGLEPLAYER OR A DIFFERENT SERVER WITH DIFFERENT MODS, DO NOT CONTINUE!
** 
** Doing this step does not allow you to change your mods, as it links the mods folder to your game.
** This is nice if you're only playing Fabric MC on our server, and using Vanilla MC otherwise.
**
** If you do NOT want the mods to automatically synchronize, do NOT do the following steps.
**************************************************************************************************

6) Open Command Prompt with Elevated Permissions (Admin)
7) Run the following command (replacing "<your_username>" with your username):
	
	mklink /D "C:/Users/<your_username>/AppData/Roaming/.Minecraft/mods" "C:/Minecraft/fabricmc/mods"

8) The mods folder will now self-update every hour your computer is running, and when it starts up, keeping it synchronized.





