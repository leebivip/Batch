@echo off

shift /0

if %0 equ ^:generateArray goto :generateArray
if %0 equ ^:releaseArray goto :releaseArray
if %0 equ ^:generateKeyValueArray goto :generateKeyValueArray

goto :eof

@rem #########################################################
@rem 
@rem 获取数组函数 
@rem 第一个参数是数组名称,后续都是参数值
@rem 
@rem #########################################################
:generateArray

set _array_length=0
:generateArrayProcess
set %1.length=%_array_length%

if "%2"=="" (goto :eof)

set %1[%_array_length%]=%2
shift /2

set /a _array_length+=1

goto :generateArrayProcess
@rem #########################################################






@rem #########################################################
@rem 
@rem 释放数组函数 
@rem 唯一参数是数组名称
@rem 
@rem #########################################################
:releaseArray

if "%1"=="" (echo please enter array_name & goto :eof)

	set /a _array_length=%1.length
	set /a _array_last_index=%_array_length%-1
	
	for /l %%i in (0,1,%_array_last_index%) do (
		set %1[%%i]=>nul
	)
	
	set %1.length=>nul
	
goto :eof
@rem #########################################################








@rem #########################################################
@rem 
@rem 获取KeyValue数组函数 
@rem 第一个参数是数组名称,后续都是Key的值
@rem 
@rem #########################################################
:generateKeyValueArray

set _array_length=0
:generateKeyValueArrayProcess
set %1.length=%_array_length%

if "%2"=="" (goto :eof)

set _KEY=%2
call set _VALUE=%%%_KEY%%%

set %1[%_array_length%].KEY=%_KEY%
set %1[%_array_length%].VALUE=%_VALUE%

shift /2

set /a _array_length+=1

goto :generateKeyValueArrayProcess
@rem #########################################################