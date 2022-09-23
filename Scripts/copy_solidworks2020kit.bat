call robocopy  \\plm\pnnas\jtdev\Group_build\SW\SWV22.0\bld\sw2022\wntx64\Release\kit\solidworks "C:\Program Files\Siemens\JTTranslators\SolidworksJT_21.1" /MIR /XD License Help

set/A errlev="%ERRORLEVEL% & 24"

exit/B %errlev%