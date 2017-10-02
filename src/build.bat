@echo off
REM Add the "bin.X86_64_WINDOWS" folder of Maple to the PATH
cmaple build.mm
mv NMPCToolkit.maple ..\build
mv NMPCToolkit.help ..\build
