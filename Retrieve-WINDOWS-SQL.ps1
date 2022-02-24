

$APP = 'SQL SERVER'

$OUT = 'C:\TEMP\Info_env.txt'

Remove-Item  "$OUT" -Force -ErrorAction SilentlyContinue

$_WindowsV =  Get-ComputerInfo | Select-Object CsName, WindowsProductName, OsVersion

Echo "$_WindowsV" | Format-table -hidetableheaders >>  "$OUT"

Start-Sleep -Seconds 5

Get-WmiObject -class win32_product | where {$_.name -like "*$APP*"  } |  Select-Object name, version  >>  "$OUT"

(Get-Content -Path "$OUT") |
    ForEach-Object {$_ -Replace '@{CsName=', 'HOSTNAME: '} |
        Set-Content -Path "$OUT"

(Get-Content -Path "$OUT") |
    ForEach-Object {$_ -Replace 'WindowsProductName=','OS: '} |
    Set-Content -Path "$OUT"

(Get-Content -Path "$OUT") |
    ForEach-Object {$_ -Replace 'OsVersion=', 'VERSAO: '} |
    Set-Content -Path "$OUT"

Start-Sleep -Seconds 2

[IO.File]::ReadAllText("$OUT") -replace '\s+\r\n+', "`r`n" | Out-File "$OUT"

#azcopy copy "C:\local\path" "https://account.blob.core.windows.net/{CONTAINER_NAME}/?{SAS_TOKEN}}" --recursive=true
