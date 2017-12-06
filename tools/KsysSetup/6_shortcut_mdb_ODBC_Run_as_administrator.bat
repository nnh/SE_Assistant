rem システムDSN　32ビット　管理者権限でバッチ起動しそのあとユーザ名とパスワード設定が必要
odbcconf /A {CONFIGSYSDSN "SQL Server" "DSN=JPLSG_SV1|DATABASE=JPLSG|SERVER=RINKEN-SV2"}
odbcconf /A {CONFIGSYSDSN "SQL Server" "DSN=JPLSG_SV2|DATABASE=JPLSG_V2|SERVER=RINKEN-SV2"}
odbcconf /A {CONFIGSYSDSN "SQL Server" "DSN=JSPHO|DATABASE=JSPH|SERVER=RINKEN-SV2"}
rem システムDSN　64ビット　管理者権限でバッチ起動しそのあとユーザ名とパスワード設定が必要
C:\Windows\SysWOW64\odbcconf.exe /a  {CONFIGSYSDSN "SQL Server" "DSN=JPLSG_SV1|DATABASE=JPLSG|SERVER=RINKEN-SV2"}
C:\Windows\SysWOW64\odbcconf.exe /a  {CONFIGSYSDSN "SQL Server" "DSN=JPLSG_SV2|DATABASE=JPLSG_V2|SERVER=RINKEN-SV2"}
C:\Windows\SysWOW64\odbcconf.exe /a  {CONFIGSYSDSN "SQL Server" "DSN=JSPHO|DATABASE=JSPH|SERVER=RINKEN-SV2"}
net use o: \\rinken-sv2\share\SystemAssistant\Ksys関連\DesktopSettingwork persistent:no
copy o:\ドキュメント\*.mdb %UserProfile%\Documents\ /y
copy o:\ドキュメント\*.accdb %UserProfile%\Documents\ /y
copy o:\*.lnk %UserProfile%\Desktop\ /y
net use o: /delete
net use n: /delete
exit
rem ユーザーDSN　32/64ビット　登録後ユーザ名とパスワードを設定
odbcconf /A {CONFIGDSN "SQL Server" "DSN=JPLSG_SV1|DATABASE=JPLSG|SERVER=RINKEN-SV2"}
odbcconf /A {CONFIGDSN "SQL Server" "DSN=JPLSG_SV2|DATABASE=JPLSG_V2|SERVER=RINKEN-SV2"}
odbcconf /A {CONFIGDSN "SQL Server" "DSN=JSPHO|DATABASE=JSPH|SERVER=RINKEN-SV2"}