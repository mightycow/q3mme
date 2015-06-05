:: This script requires WinRAR to be in your PATH.
:: If you don't want to add it, you can do something like this:
::PATH=%PATH%;C:\Program Files\WinRAR

WinRAR.exe a -ep -apdata pak0.zip redist\data\*
WinRAR.exe a -ep -apscripts pak0.zip redist\scripts\*
ren pak0.zip pak0.pk3

WinRAR.exe a -ep -ap q3mme.zip .bin\release\quake3mme.exe
WinRAR.exe a -ep -ap q3mme.zip libs\freetype\x86\freetype.dll
WinRAR.exe a -ep -ap q3mme.zip libs\jpeg-turbo\x86\jpeg62.dll
WinRAR.exe a -ep -apmme q3mme.zip .bin\release\cgamex86.dll
WinRAR.exe a -ep -apmme q3mme.zip .bin\release\qagamex86.dll
WinRAR.exe a -ep -apmme q3mme.zip .bin\release\uix86.dll
WinRAR.exe a -ep -apmme\docs q3mme.zip redist\*.txt
WinRAR.exe a -ep -apmme q3mme.zip pak0.pk3
del pak0.pk3