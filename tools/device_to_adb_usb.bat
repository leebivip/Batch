@echo off & setlocal enabledelayedexpansion

call :getEnvironment

if "!sdk_path!"=="" (
	echo 获取android_sdk 路径失败,请手动输入路径
	set /p sdk_path=
)


call :main

pause
goto :eof


rem ////////////////////////////////////////////////////////
:main


echo 将adb默认不识别的手机ID添加到adb_usb.ini以便让adb识别
echo 执行前只连接一台手机
echo 只执行添加,不对adb_usb.ini里面的ID进行去重
echo.


set /p system_in=ready to add device to adb_usb? y/n   

if "%system_in%"=="y" (
	call :executeAdd
) else (
	if "%system_in%"=="n" (
		echo.
		goto :main
	)
)

goto :eof
rem \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


rem ////////////////////////////////////////////////////////
:executeAdd

echo prepare to add device to adb_usb
echo.

call :getDeviceID

if not "!device_id!"=="" (
	echo. >>!sdk_path!.android\adb_usb.ini
	echo 0x!device_id!>>!sdk_path!.android\adb_usb.ini
	echo add device sucess
	echo.

	adb kill-server
	adb start-server
	
) else (
	echo add device faild
	echo.
)

goto :eof
rem \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


rem ////////////////////////////////////////////////////////
:getDeviceID

echo prepare to get device_id
echo.

for /f "usebackq tokens=2 delims=\ skip=1" %%a in (`Wmic Path Win32_USBHub where "Caption='USB Composite Device'" Get DeviceID`) do (
	set id_str=%%a
	
	set device_id=!id_str:~4,4!
)

goto :eof
rem \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


rem ////////////////////////////////////////////////////////
:getEnvironment

echo prepare to get android_sdk dir
echo.

for /f "tokens=1,2* delims==;" %%a in ('path') do set loopstr=%%c & call :getEnvironmentLoop

goto :eof
rem \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


rem ////////////////////////////////////////////////////////
:getEnvironmentLoop

if "%loopstr%"=="" goto :eof
for /f "tokens=1* delims=;" %%a in ("%loopstr%") do (
	
	if exist %%a\adb.exe (
		set sdk_str=%%a
		set sdk_path=!sdk_str:~0,-14!
	)
	
	set loopstr=%%b
)

goto getEnvironmentLoop
rem \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\