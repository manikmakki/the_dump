@echo off
pushd "%~dp0"
cls
:pingws
echo Push LSAgent to remote computers, sneaky snek.
echo Working Dir: %CD%
set /p id="Enter IP of remote workstation: "
nslookup %id%
ping %id%
set /p resp="Do you want to continue installation? [y]es, [n]o: "
if [%resp%]== [n] (
	echo Let's try again...
	GOTO :pingws
)
if [%resp%]== [y] (
	GOTO :install
)
:install
psexec \\%id% -c -f LsAgent-windows.exe --server 192.168.2.8 --port 9524 --mode unattended
set /p conf="Want to do another? [y]es, [n]o, [r]etry: "
if [%conf%]== [y] (
	GOTO :pingws
)
if [%conf%]== [n] (
	GOTO :exit
)
if [%conf%]== [r] (
	GOTO :install
)
:exit
echo All Done
pause
