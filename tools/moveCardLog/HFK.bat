@echo off
set targetdir=%userprofile%\Downloads
for /f "usebackq tokens=*" %%a in (%targetdir%\HFK.csv) do @set HEAD0=%%a&goto :exit_for0
:exit_for0
for /f "usebackq tokens=*" %%a in ("%targetdir%\HFK (1).csv") do @set HEAD1=%%a&goto :exit_for1
:exit_for1
for /f "usebackq tokens=*" %%a in ("%targetdir%\HFK (2).csv") do @set HEAD2=%%a&goto :exit_for2
:exit_for2

set renname0=%HEAD0:~8,4%%HEAD0:~13,2%%HEAD0:~16,2%-%HEAD0:~30,4%%HEAD0:~35,2%%HEAD0:~38,2%HFK.csv
set renname1=%HEAD1:~8,4%%HEAD1:~13,2%%HEAD1:~16,2%-%HEAD1:~30,4%%HEAD1:~35,2%%HEAD1:~38,2%HFK.csv
set renname2=%HEAD2:~8,4%%HEAD2:~13,2%%HEAD2:~16,2%-%HEAD2:~30,4%%HEAD2:~35,2%%HEAD2:~38,2%HFK.csv
echo %renname0%
echo %renname1%
echo %renname2%
ren %targetdir%\HFK.csv %renname0%
ren "%targetdir%\HFK (1).csv" %renname1%
ren "%targetdir%\HFK (2).csv" %renname2%
set yyyy=%date:~0,4%
set mm=%date:~5,2%
if %mm:~0,1%==0 ( 
  set tempmm=%mm:~1,1%
  if %mm:~1,1%==1 ( 
    set /a tempyyyy=%yyyy%-1 
  ) else (  
    set tempyyyy=%yyyy% 
  )   
) else ( 
  set tempmm=%mm%
  set tempyyyy=%yyyy% 
) 
set /a lastmm=%tempmm%-1
if %lastmm% lss 10 (  
  set lastmm=0%lastmm%
)  
echo %tempyyyy%
echo %lastmm%
set foldername=%tempyyyy:~0,4%%lastmm:~0,2%
echo %foldername%
set dirname=\\aronas\Archives\Log\DC“ü‘ÞŽº\rawdata\%foldername%
mkdir %dirname%
cd %userprofile%\Downloads
move %renname0% %dirname%\%renname0%
move %renname1% %dirname%\%renname1%
move %renname2% %dirname%\%renname2%
