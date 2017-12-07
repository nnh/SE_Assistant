echo off
set USR=mariko.ohtsuka
set PASSWD=
set /p PASSWD=%USR% Enter your password:
net use \\172.16.0.222\Projects  /delete
net use \\ARONAS\Projects  /delete
net use \\172.16.0.222\Projects %PASSWD%  /user:%USR%
net use \\ARONAS\Projects %PASSWD%  /user:%USR%
