@echo on
set thisYear=%date:~0,4%
set /a lastYear=%thisYear%-1
set isoKirokuDir="%userprofile%\Box\Projects\ISO\QMS・ISMS文書\04 記録"
set isms=ISMS（情報システム研究室）
set qms=QMS（情報システム研究室）
set lastKotei=%isoKirokuDir%\%lastYear%年度\固定
set thisDraft=%isoKirokuDir%\%thisYear%年度\ドラフト
robocopy %lastKotei%\%isms% %thisDraft%\%isms% /max:1
robocopy %lastKotei%\%qms% %thisDraft%\%qms% /max:1
pause
