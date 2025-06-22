# Set URL sumber file
$batUrl    = 'https://file.mocina.my.id/uploads/installer.bat'
$batFile   = "$env:TEMP\installer.bat"

$aria2Url  = 'https://file.mocina.my.id/uploads/aria2c.exe'
$aria2File = "$env:TEMP\aria2c.exe"

# Fungsi warna output
function Write-Info($msg)    { Write-Host "[INFO]  $msg" -ForegroundColor Cyan }
function Write-Success($msg) { Write-Host "[ OK ]  $msg" -ForegroundColor Green }
function Write-ErrorMsg($msg){ Write-Host "[FAIL]  $msg" -ForegroundColor Red }

# Mulai download
Write-Info "Mengunduh installer.bat..."
try {
    Invoke-WebRequest -Uri $batUrl -OutFile $batFile -ErrorAction Stop
    Write-Success "Berhasil mengunduh installer.bat"
} catch {
    Write-ErrorMsg "Gagal mengunduh installer.bat"
    exit 1
}

Write-Info "Mengunduh aria2c.exe..."
try {
    Invoke-WebRequest -Uri $aria2Url -OutFile $aria2File -ErrorAction Stop
    Write-Success "Berhasil mengunduh aria2c.exe"
} catch {
    Write-ErrorMsg "Gagal mengunduh aria2c.exe"
    exit 1
}

# Jalankan installer.bat
Write-Info "Menjalankan installer..."
cmd /c $batFile
