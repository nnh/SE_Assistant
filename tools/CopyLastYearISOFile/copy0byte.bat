@echo on
set thisYear=%date:~0,4%
set /a lastYear=%thisYear%-1
set isoKirokuDir="%userprofile%\Box\Projects\ISO\QMS�EISMS����\04 �L�^"
set isms=ISMS�i���V�X�e���������j
set qms=QMS�i���V�X�e���������j
set lastKotei=%isoKirokuDir%\%lastYear%�N�x\�Œ�
set thisDraft=%isoKirokuDir%\%thisYear%�N�x\�h���t�g
robocopy %lastKotei%\%isms% %thisDraft%\%isms% /max:1
robocopy %lastKotei%\%qms% %thisDraft%\%qms% /max:1
pause
