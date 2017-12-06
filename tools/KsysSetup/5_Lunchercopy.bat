net use n: \\rinken-sv2\share\System persistent:no
xcopy n:\bin2\S00_Comm_00_Luncher.exe c:\System\bin  /E /-Y /H
xcopy n:\bin2\Luncher.ini c:\System\bin  /E /-Y /H
xcopy n:\bin2\S00_Comm_00_Luncher.exe c:\System\bin2  /E /-Y /H
xcopy n:\bin2\Luncher.ini c:\System\bin2  /E /-Y /H
xcopy n:\bin2\S00_Comm_00_Luncher.exe c:\System\bin2test  /E /-Y /H
xcopy n:\bin2\Luncher.ini c:\System\bin2test  /E /-Y /H
net use n: /delete
