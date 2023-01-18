call robocopy  \\plm\pnnas\jtdev\Group_build\SW\SWV23.0\bld\sw2023\wntx64\Release\kit\solidworks "C:\Program Files\Siemens\JTTranslators\SolidworksJT_23.0.0" /MIR /XD License Help

set/A errlev="%ERRORLEVEL% & 24"

exit/B %errlev%
