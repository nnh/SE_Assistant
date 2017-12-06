net use n: \\rinken-sv2\share\System persistent:no
xcopy n:\Setup %UserProfile%\Desktop\Setup /I /E /-Y /H 
pause
start %UserProfile%\Desktop\Setup\setup.exe 
net use n: /delete
