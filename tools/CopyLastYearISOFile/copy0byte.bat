@echo on
set thisYear=%date:~0,4%
set /a lastYear=%thisYear%-1
set "isoKirokuDir=%userprofile%\Box\Projects\ISO\QMS�EISMS����\04 �L�^"
set isms=ISMS�i���V�X�e���������j
set qms=QMS�i���V�X�e���������j
set lastKotei=%isoKirokuDir%\%lastYear%�N�x\�Œ�
set thisDraft=%isoKirokuDir%\%thisYear%�N�x\�h���t�g
robocopy %lastKotei%\%isms% %thisDraft%\%isms% /max:1
robocopy %lastKotei%\%qms% %thisDraft%\%qms% /max:1
copy "%lastKotei%\%isms%\ISF19 �d�l��.txt" "%thisDraft%\%isms%\ISF19 �d�l��.txt"
set "logdata=ISF22 ���O�f�[�^ "
copy "%lastKotei%\%isms%\%logdata%DC���ގ�.txt" "%thisDraft%\%isms%\%logdata%DC���ގ�.txt"
copy "%lastKotei%\%isms%\%logdata%PivotalTracker.txt" "%thisDraft%\%isms%\%logdata%PivotalTracker.txt"
copy "%lastKotei%\%isms%\%logdata%UTM.txt" "%thisDraft%\%isms%\%logdata%UTM.txt"
copy "%lastKotei%\%isms%\%logdata%VPN.txt" "%thisDraft%\%isms%\%logdata%VPN.txt"
copy "%lastKotei%\%isms%\ISF29 �T�[�o����ƕ񍐏�.txt" "%thisDraft%\%isms%\ISF29 �T�[�o����ƕ񍐏�.txt"
robocopy "%lastKotei%\%isms%" "%thisDraft%\%isms%" "ISF15 �X�P*���[���\PIVOTAL TRACKER.pdf"
set "kyouiku=\Box\Projects\ISO\QMS�EISMS����\06 ���̑�\���C����"\
set "qf30=%kyouiku%\%thisYear%�N�x"
echo %qf30% > "%thisDraft%\%qms%\QF30 ���玑��.txt"
pause
