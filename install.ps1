$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityPointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$LogFile = Join-Path $env:TEMP "installer.log"

function Write-Log($Level,$Message){
    $ts=Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line="[$ts] [$Level] $Message"
    Add-Content -Path $LogFile -Value $line
    switch($Level){
        "INFO"{Write-Host $line -ForegroundColor Cyan}
        "OK"{Write-Host $line -ForegroundColor Green}
        "FAIL"{Write-Host $line -ForegroundColor Red}
        default{Write-Host $line}
    }
}
function Invoke-DownloadWithRetry{
param([string]$Uri,[string]$OutFile,[int]$Retry=3)
    Remove-Item $OutFile -Force -ErrorAction SilentlyContinue
    for($i=1;$i -le $Retry;$i++){
        try{
            Write-Log INFO "Download ($i/$Retry): $Uri"
            Invoke-WebRequest -Uri $Uri -OutFile $OutFile -UseBasicParsing -TimeoutSec 60
            if(!(Test-Path $OutFile)){throw "File tidak ditemukan."}
            if((Get-Item $OutFile).Length -le 0){throw "File kosong."}
            Write-Log OK "Download selesai: $OutFile"
            return
        }catch{
            Write-Log FAIL $_.Exception.Message
            if($i -lt $Retry){Start-Sleep 2}else{throw}
        }
    }
}

$batUrl='https://file.mocina.my.id/uploads/installer.bat'
$batFile="$env:TEMP\installer.bat"
$aria2ZipUrl='https://file.mocina.my.id/uploads/aria2c.exe'
$aria2Folder="$env:TEMP\aria2"
$aria2Exe="$aria2Folder\aria2c.exe"
$aria2ZipPath="$env:TEMP\aria2c.exe"

try{
    Write-Log INFO "Memulai installer"

    Invoke-DownloadWithRetry -Uri $batUrl -OutFile $batFile

    if(!(Test-Path $aria2Exe) -or ((Get-Item $aria2Exe).Length -le 0)){
        if(!(Test-Path $aria2Folder)){
            New-Item -ItemType Directory -Path $aria2Folder -Force|Out-Null
        }
        Invoke-DownloadWithRetry -Uri $aria2ZipUrl -OutFile $aria2ZipPath
        Move-Item $aria2ZipPath $aria2Exe -Force -ErrorAction Stop
        Write-Log OK "aria2 siap"
    }else{
        Write-Log INFO "aria2 sudah tersedia"
    }

    $env:PATH="$aria2Folder;$env:PATH"
    Write-Log INFO "Menjalankan installer.bat"
    & cmd.exe /c "`"$batFile`""
    $ec=$LASTEXITCODE
    Write-Log INFO "ExitCode: $ec"
    if($ec -ne 0){throw "installer.bat exit code $ec"}
    Write-Log OK "Selesai"
}
catch{
    Write-Log FAIL $_.Exception.Message
    if($_.InvocationInfo){
        Write-Host ""
        Write-Host $_.InvocationInfo.PositionMessage -ForegroundColor Yellow
    }
    if($_.ScriptStackTrace){
        Write-Host ""
        Write-Host $_.ScriptStackTrace -ForegroundColor DarkYellow
    }
}
finally{
    Read-Host "Tekan ENTER untuk keluar"
}
