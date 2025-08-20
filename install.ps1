# Set lokasi dan URL
$batUrl    = 'https://file.mocina.my.id/uploads/installer.bat'
$batFile   = "$env:TEMP\installer.bat"

$aria2ZipUrl  = 'https://file.mocina.my.id/uploads/aria2c.exe' #ini diganti ya ges, gapake yg zip lagi  tp variable nya sama
$aria2Folder  = "$env:TEMP\aria2"
$aria2Exe     = "$aria2Folder\aria2c.exe"
$aria2ZipPath = "$env:TEMP\aria2c.exe" #ganti dari .zip jadi .exe

# Fungsi warna output
function Write-Info($msg)    { Write-Host "[INFO]  $msg" -ForegroundColor Cyan }
function Write-Success($msg) { Write-Host "[ OK ]  $msg" -ForegroundColor Green }
function Write-ErrorMsg($msg){ Write-Host "[FAIL]  $msg" -ForegroundColor Red }

# Unduh installer.bat (selalu update)
Write-Info "Mengunduh installer.bat..."
try {
    Invoke-WebRequest -Uri $batUrl -OutFile $batFile -ErrorAction Stop
    Write-Success "Berhasil mengunduh installer.bat"
} catch {
    Write-ErrorMsg "Gagal mengunduh installer.bat"
    exit 1
}

# Cek apakah aria2c.exe sudah ada
if (Test-Path $aria2Exe) {
    Write-Info "aria2c.exe sudah tersedia di folder %TEMP%\aria2"
} else {
    # Download ZIP
    Write-Info "Mengunduh aria2c"
    try {
        Invoke-WebRequest -Uri $aria2ZipUrl -OutFile $aria2ZipPath -ErrorAction Stop
        Write-Success "Berhasil mengunduh aria2c"
    } catch {
        Write-ErrorMsg "Gagal mengunduh aria2c.zip"
        exit 1
    }


# line ini gak perlu 
    # Ekstrak
 #   Write-Info "Mengekstrak aria2c.zip ke folder: $aria2Folder"
 #   try {
 #       Expand-Archive -Path $aria2ZipPath -DestinationPath $aria2Folder -Force
 #       Write-Success "Ekstraksi berhasil"
 #   } catch {
 #       Write-ErrorMsg "Gagal mengekstrak aria2c.zip"
 #       exit 1
 #   }
}

# Jalankan installer.bat dengan PATH yang sudah include aria2
Write-Info "Menjalankan installer..."
$env:PATH = "$aria2Folder;$env:PATH"
cmd /c $batFile

