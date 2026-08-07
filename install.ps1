```powershell
# ==============================
# Set lokasi dan URL
# ==============================

$batUrl = "https://file.mocina.my.id/uploads/installer.bat"
$batFile = "$env:TEMP\installer.bat"

# aria2c sekarang langsung EXE, bukan ZIP
$aria2ZipUrl = "https://file.mocina.my.id/uploads/aria2c.exe"
$aria2Folder = "$env:TEMP\aria2"
$aria2Exe = "$aria2Folder\aria2c.exe"
$aria2ZipPath = "$env:TEMP\aria2c.exe"


# ==============================
# Fungsi warna output
# ==============================

function Write-Info($msg) {
    Write-Host "[INFO]  $msg" -ForegroundColor Cyan
}

function Write-Success($msg) {
    Write-Host "[ OK ]  $msg" -ForegroundColor Green
}

function Write-ErrorMsg($msg) {
    Write-Host "[FAIL]  $msg" -ForegroundColor Red
}


# ==============================
# Buat folder aria2 jika belum ada
# ==============================

if (-not (Test-Path $aria2Folder)) {
    New-Item -ItemType Directory -Path $aria2Folder -Force | Out-Null
}


# ==============================
# Unduh installer.bat (selalu update)
# ==============================

Write-Info "Mengunduh installer.bat..."

try {
    Invoke-WebRequest `
        -Uri $batUrl `
        -OutFile $batFile `
        -ErrorAction Stop

    Write-Success "Berhasil mengunduh installer.bat"
}
catch {
    Write-ErrorMsg "Gagal mengunduh installer.bat"
    exit 1
}


# ==============================
# Cek apakah aria2c.exe sudah ada
# ==============================

if (Test-Path $aria2Exe) {

    Write-Info "aria2c.exe sudah tersedia di folder $aria2Folder"

}
else {

    Write-Info "Mengunduh aria2c.exe..."

    try {
        Invoke-WebRequest `
            -Uri $aria2ZipUrl `
            -OutFile $aria2ZipPath `
            -ErrorAction Stop

        # Pindahkan ke folder aria2
        Move-Item `
            -Path $aria2ZipPath `
            -Destination $aria2Exe `
            -Force

        Write-Success "Berhasil mengunduh aria2c.exe"
    }
    catch {
        Write-ErrorMsg "Gagal mengunduh aria2c.exe"
        exit 1
    }
}


# ==============================
# Jalankan installer.bat
# dengan PATH yang sudah include aria2
# ==============================

Write-Info "Menjalankan installer..."

$env:PATH = "$aria2Folder;$env:PATH"

cmd.exe /c $batFile

if ($LASTEXITCODE -eq 0) {
    Write-Success "installer.bat selesai dijalankan"
}
else {
    Write-ErrorMsg "installer.bat selesai dengan exit code $LASTEXITCODE"
}

