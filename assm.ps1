# Run this script with XAS99 to assemble all files
# See https://endlos99.github.io/xdt99/
#
# If you can't run powershell scripts research this command locally:
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
param([string]$mode='debug')

write-host 'Creating Cartridge'

if ($mode -ne 'release') {
    $mode = 'debug'
}

$fileList = 'VAR', 'MAIN', 'KSCAN', 'VDP', 'CHARPAT', 'IMGDATA', 'COPYIMG', 'VWRITE', 'MESSAGE'

#Deleting old work files
write-host 'Deleting old work files'
ForEach($file in $fileList) {
    $objFile = $file + '.obj'
    $lstfile = $file + '.lst'
    if (Test-Path $objFile) { Remove-Item $objFile }
    if (Test-Path $lstFile) { Remove-Item $lstFile }
}

#Assembling files
write-host 'Assembling source code'
ForEach($file in $fileList) {
    $asmFile = $file + '.asm'
    $lstFile = $file + '.lst'
    write-host '    ' $asmFile
    xas99.py $asmFile -S -R -L $lstFile
}

#Exit if assembly errors found
ForEach($file in $fileList) {
    $objFile = $file + '.obj'
    if (-not(Test-Path $objFile)) {
        exit
    }
}

#Link object files into cartridge
write-host 'Creating cartridge'
$outputCartridgeFile = 'MultiColorSpeedC.bin'
xas99.py -b -a ">6000" -o $outputCartridgeFile -l `
    MAIN.obj `
    VAR.obj `
    KSCAN.obj `
    VDP.obj `
    CHARPAT.obj `
    IMGDATA.obj `
    COPYIMG.obj `
    VWRITE.obj `
    MESSAGE.obj

#Create .rpk file for MAME
$zipFileName = ".\MultiColorSpeed.zip"
$rpkFileName = ".\MultiColorSpeed.rpk"
compress-archive -Path ".\layout.xml",$outputCartridgeFile $zipFileName -compressionlevel optimal
if (Test-Path $rpkFileName) { Remove-Item $rpkFileName }
Rename-Item $zipFileName $rpkFileName    

#Delete work files
write-host 'Deleting work files'
ForEach($file in $fileList) {
    $objFile = $file + '.obj'
    $lstfile = $file + '.lst'
    Remove-Item $objFile
    Remove-Item $lstFile
}