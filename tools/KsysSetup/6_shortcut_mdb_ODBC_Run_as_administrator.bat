rem SYSTEM DSN 32bit
odbcconf /A {CONFIGSYSDSN "SQL Server" "DSN=JPLSG_SV1|DATABASE=JPLSG|SERVER=RINKEN-SV2"}
odbcconf /A {CONFIGSYSDSN "SQL Server" "DSN=JPLSG_SV2|DATABASE=JPLSG_V2|SERVER=RINKEN-SV2"}
odbcconf /A {CONFIGSYSDSN "SQL Server" "DSN=JSPHO|DATABASE=JSPH|SERVER=RINKEN-SV2"}
rem SYSTEM DSN 64bit
C:\Windows\SysWOW64\odbcconf.exe /a  {CONFIGSYSDSN "SQL Server" "DSN=JPLSG_SV1|DATABASE=JPLSG|SERVER=RINKEN-SV2"}
C:\Windows\SysWOW64\odbcconf.exe /a  {CONFIGSYSDSN "SQL Server" "DSN=JPLSG_SV2|DATABASE=JPLSG_V2|SERVER=RINKEN-SV2"}
C:\Windows\SysWOW64\odbcconf.exe /a  {CONFIGSYSDSN "SQL Server" "DSN=JSPHO|DATABASE=JSPH|SERVER=RINKEN-SV2"}
net use o: \\rinken-sv2\share\SystemAssistant\Ksys\DesktopSettingwork persistent:no
copy o:\Documents\*.accdb %UserProfile%\Documents\ /y
copy o:\*.lnk %UserProfile%\Desktop\ /y
net use o: /delete
net use n: /delete
exit
rem USER DSN 32/64bit
odbcconf /A {CONFIGDSN "SQL Server" "DSN=JPLSG_SV1|DATABASE=JPLSG|SERVER=RINKEN-SV2"}
odbcconf /A {CONFIGDSN "SQL Server" "DSN=JPLSG_SV2|DATABASE=JPLSG_V2|SERVER=RINKEN-SV2"}
odbcconf /A {CONFIGDSN "SQL Server" "DSN=JSPHO|DATABASE=JSPH|SERVER=RINKEN-SV2"}