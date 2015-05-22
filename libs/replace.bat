@echo off

shift /0

if %0 equ ^:replaceFileLine goto :replaceFileLine

goto :eof



@rem #########################################################
@rem 
@rem 替换文件文本函数 
@rem /r 代表使用正则查询行并且使用TargetStr替换整行,字符串必须要加双引号
@rem [/r] SrcFileName SrcStr TargetStr
@rem 
@rem #########################################################
:replaceFileLine

setlocal enabledelayedexpansion

if %1==/r (set isRegex=true & shift/1) else (set isRegex=false)

set SrcFileName=%1
set SrcStr=%2
set TargetStr=%3

REM 
set SrcStr=%SrcStr:~1,-1%
REM 
set TargetStr=%TargetStr:~1,-1%

set TempFileName=%SrcFileName%.temp

echo %isRegex% %SrcFileName% %SrcStr% %TargetStr%


if exist "%TempFileName%" (del "%TempFileName%")

REM 
for /f "tokens=1* delims=" %%i in ('findstr .* "%SrcFileName%"') do (
	set line=%%i
	
	if %isRegex%==true (	
		for /f "tokens=1 delims=" %%j in ('echo !line! ^| findstr /r "%SrcStr%"') do (
			set "line=%TargetStr%"
		)
	)
	
	if %isRegex%==false  (
		set "line=!line:%SrcStr%=%TargetStr%!"
	)
	
	echo !line! >>"%TempFileName%"
)

move "%TempFileName%" %SrcFileName%

goto :eof