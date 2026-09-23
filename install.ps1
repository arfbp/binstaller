# Set lokasi dan URL
$batUrl    = 'https://raw.githubusercontent.com/arfbp/binstaller/refs/heads/main/installer.bat'
$batFile   = "$env:TEMP\installer.bat"

$aria2Url    = 'https://raw.githubusercontent.com/arfbp/binstaller/refs/heads/main/aria2c.exe'
$aria2Exe  = "$env:TEMP\aria2.exe"

# Fungsi warna output
function Write-Info($msg)    { Write-Host "[INFO]  $msg" -ForegroundColor Cyan }
function Write-Success($msg) { Write-Host "[ OK ]  $msg" -ForegroundColor Green }
function Write-ErrorMsg($msg){ Write-Host "[FAIL]  $msg" -ForegroundColor Red }


Invoke-WebRequest -Uri $aria2Url -OutFile $aria2Exe -UseBasicParsing -ErrorAction Stop
sleep 3

# Create aria2 folder if not exists
#if (-not (Test-Path $aria2Folder)) {
#    New-Item -ItemType Directory -Path $aria2Folder -Force | Out-Null
#}
<#
# Check existing aria2c.exe
$needDownload = $true

if (Test-Path $aria2Exe) {
    $fileSize = (Get-Item $aria2Exe).Length

    if ($fileSize -ge 5MB) {
        Write-Info "aria2c.exe found. Size: $([math]::Round($fileSize / 1MB, 2)) MB"
        $needDownload = $false
    }
    else {
        Write-Info "aria2.exe is invalid. Size: $([math]::Round($fileSize / 1MB, 2)) MB (< 5 MB)"
        Write-Info "Force downloading new aria2.exe..."
        Remove-Item $aria2Exe -Force -ErrorAction SilentlyContinue
    }
}

# Download aria2c.exe (langsung ke lokasi final, tanpa lewat zip)
if ($needDownload) {
    Write-Info "Downloading aria2.exe..."

    try {
        Invoke-WebRequest -Uri $aria2Url -OutFile $aria2Exe -UseBasicParsing -ErrorAction Stop
    } catch {
        throw "Failed to download aria2c.exe: $_"
    }

    if (-not (Test-Path $aria2Exe)) {
        throw "Failed to download aria2c.exe."
    }

    $downloadedSize = (Get-Item $aria2Exe).Length

    if ($downloadedSize -lt 5MB) {
        Remove-Item $aria2Exe -Force -ErrorAction SilentlyContinue
        throw "Downloaded aria2c.exe is invalid. File size is below 5 MB."
    }

    Write-Success "aria2c.exe downloaded successfully. Size: $([math]::Round($downloadedSize / 1MB, 2)) MB"
}

# Final validation
if (-not (Test-Path $aria2Exe)) {
    throw "aria2c.exe not found: $aria2Exe"
}

#>
# Unduh installer.bat (selalu update)
Write-Info "Mengunduh installer.bat..."
try {
    Invoke-WebRequest -Uri $batUrl -OutFile $batFile -UseBasicParsing -ErrorAction Stop
    Write-Success "Berhasil mengunduh installer.bat"
} catch {
    Write-ErrorMsg "Gagal mengunduh installer.bat"
    exit 1
}

# Jalankan installer.bat dengan PATH yang sudah include aria2
Write-Info "Menjalankan installer..."
$env:PATH = "$aria2exe;$env:PATH"
cmd /c $batFile
