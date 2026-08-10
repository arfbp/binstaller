# Set lokasi dan URL
$batUrl    = 'https://raw.githubusercontent.com/arfbp/binstaller/refs/heads/main/installer.bat'
$batFile   = "$env:TEMP\installer.bat"


$aria2ZipUrl  = 'https://github.com/arfbp/binstaller/raw/refs/heads/main/aria2c.exe'
$aria2Folder  = "$env:TEMP\aria2"
$aria2Exe     = "$aria2Folder\aria2c.exe"
$aria2ZipPath = "$env:TEMP\aria2c.exe"


# Create aria2 folder if not exists
if (-not (Test-Path $aria2Folder)) {
    New-Item -ItemType Directory -Path $aria2Folder -Force | Out-Null
}


# Check existing aria2c.exe
$needDownload = $true

if (Test-Path $aria2Exe) {
    $fileSize = (Get-Item $aria2Exe).Length

    if ($fileSize -ge 5MB) {
        Write-Host "aria2c.exe found. Size: $([math]::Round($fileSize / 1MB, 2)) MB"
        $needDownload = $false
    }
    else {
        Write-Host "aria2c.exe is invalid. Size: $([math]::Round($fileSize / 1MB, 2)) MB (< 5 MB)"
        Write-Host "Force downloading new aria2c.exe..."

        Remove-Item $aria2Exe -Force -ErrorAction SilentlyContinue
    }
}


# Download aria2c.exe
if ($needDownload) {
    Write-Host "Downloading aria2c.exe..."

    Invoke-WebRequest `
        -Uri $aria2ZipUrl `
        -OutFile $aria2ZipPath `
        -UseBasicParsing

    # Validate downloaded file
    if (-not (Test-Path $aria2ZipPath)) {
        throw "Failed to download aria2c.exe."
    }

    $downloadedSize = (Get-Item $aria2ZipPath).Length

    if ($downloadedSize -lt 5MB) {
        Remove-Item $aria2ZipPath -Force -ErrorAction SilentlyContinue
        throw "Downloaded aria2c.exe is invalid. File size is below 5 MB."
    }

    # Move downloaded EXE to aria2 folder
    Move-Item `
        -Path $aria2ZipPath `
        -Destination $aria2Exe `
        -Force

    Write-Host "aria2c.exe downloaded successfully."
}


# Final validation
if (-not (Test-Path $aria2Exe)) {
    throw "aria2c.exe not found: $aria2Exe"
}



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
