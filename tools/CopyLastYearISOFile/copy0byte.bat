@echo on
set thisYear=%date:~0,4%
set /a lastYear=%thisYear%-1
set "isoKirokuDir=%userprofile%\Box\Projects\ISO\QMS・ISMS文書\04 記録"
set isms=ISMS（情報システム研究室）
set qms=QMS（情報システム研究室）
set lastKotei=%isoKirokuDir%\%lastYear%年度\固定
set thisDraft=%isoKirokuDir%\%thisYear%年度\ドラフト
robocopy %lastKotei%\%isms% %thisDraft%\%isms% /max:1
robocopy %lastKotei%\%qms% %thisDraft%\%qms% /max:1
copy "%lastKotei%\%isms%\ISF19 仕様書.txt" "%thisDraft%\%isms%\ISF19 仕様書.txt"
set "logdata=ISF22 ログデータ "
copy "%lastKotei%\%isms%\%logdata%DC入退室.txt" "%thisDraft%\%isms%\%logdata%DC入退室.txt"
copy "%lastKotei%\%isms%\%logdata%PivotalTracker.txt" "%thisDraft%\%isms%\%logdata%PivotalTracker.txt"
copy "%lastKotei%\%isms%\%logdata%UTM.txt" "%thisDraft%\%isms%\%logdata%UTM.txt"
copy "%lastKotei%\%isms%\%logdata%VPN.txt" "%thisDraft%\%isms%\%logdata%VPN.txt"
copy "%lastKotei%\%isms%\ISF29 サーバ室作業報告書.txt" "%thisDraft%\%isms%\ISF29 サーバ室作業報告書.txt"
robocopy "%lastKotei%\%isms%" "%thisDraft%\%isms%" "ISF15 スケ*ュール表PIVOTAL TRACKER.pdf"
set "kyouiku=\Box\Projects\ISO\QMS・ISMS文書\06 その他\研修資料"\
set "qf30=%kyouiku%\%thisYear%年度"
echo %qf30% > "%thisDraft%\%qms%\QF30 教育資料.txt"
pause
