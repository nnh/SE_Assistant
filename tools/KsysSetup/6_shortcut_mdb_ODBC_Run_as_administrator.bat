rem �V�X�e��DSN�@32�r�b�g�@�Ǘ��Ҍ����Ńo�b�`�N�������̂��ƃ��[�U���ƃp�X���[�h�ݒ肪�K�v
odbcconf /A {CONFIGSYSDSN "SQL Server" "DSN=JPLSG_SV1|DATABASE=JPLSG|SERVER=RINKEN-SV2"}
odbcconf /A {CONFIGSYSDSN "SQL Server" "DSN=JPLSG_SV2|DATABASE=JPLSG_V2|SERVER=RINKEN-SV2"}
odbcconf /A {CONFIGSYSDSN "SQL Server" "DSN=JSPHO|DATABASE=JSPH|SERVER=RINKEN-SV2"}
rem �V�X�e��DSN�@64�r�b�g�@�Ǘ��Ҍ����Ńo�b�`�N�������̂��ƃ��[�U���ƃp�X���[�h�ݒ肪�K�v
C:\Windows\SysWOW64\odbcconf.exe /a  {CONFIGSYSDSN "SQL Server" "DSN=JPLSG_SV1|DATABASE=JPLSG|SERVER=RINKEN-SV2"}
C:\Windows\SysWOW64\odbcconf.exe /a  {CONFIGSYSDSN "SQL Server" "DSN=JPLSG_SV2|DATABASE=JPLSG_V2|SERVER=RINKEN-SV2"}
C:\Windows\SysWOW64\odbcconf.exe /a  {CONFIGSYSDSN "SQL Server" "DSN=JSPHO|DATABASE=JSPH|SERVER=RINKEN-SV2"}
net use o: \\rinken-sv2\share\SystemAssistant\Ksys�֘A\DesktopSettingwork persistent:no
copy o:\�h�L�������g\*.mdb %UserProfile%\Documents\ /y
copy o:\�h�L�������g\*.accdb %UserProfile%\Documents\ /y
copy o:\*.lnk %UserProfile%\Desktop\ /y
net use o: /delete
net use n: /delete
exit
rem ���[�U�[DSN�@32/64�r�b�g�@�o�^�テ�[�U���ƃp�X���[�h��ݒ�
odbcconf /A {CONFIGDSN "SQL Server" "DSN=JPLSG_SV1|DATABASE=JPLSG|SERVER=RINKEN-SV2"}
odbcconf /A {CONFIGDSN "SQL Server" "DSN=JPLSG_SV2|DATABASE=JPLSG_V2|SERVER=RINKEN-SV2"}
odbcconf /A {CONFIGDSN "SQL Server" "DSN=JSPHO|DATABASE=JSPH|SERVER=RINKEN-SV2"}