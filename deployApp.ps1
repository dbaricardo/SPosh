$cmps = get-content C:\Temp\host.txt
$Desligados = new-object system.collections.arraylist
$Atualizados = new-object system.collections.arraylist
foreach ($cmp in $cmps) {

if(Test-Connection -cn $cmp -count 1 -quiet){

    $service = (get-service -name aderenciamonitor -ComputerName $cmp | Where-Object { $_.status -eq "running" })
    $service.stop();
    foreach($computer in $proc = get-Process -computername $cmp -name *.Adherence.Client.*){

    taskkill /S $cmp /PID $computer.id

    }
    

    $cmp_atu = "\\" + $cmp

    

    Copy-item -Path "C:\temp\aderencia_6.1.0.21.msi" -Destination $cmp_atu\c$\temp\
    $process = [WMICLASS]"$cmp_atu\ROOT\CIMV2:win32_process"
    $command = "msiexec.exe /x {08D4C6CA-4202-49F3-9A60-D0BF112A5D81} /quiet"
    $result = $process.Create($command)
    Start-Sleep 4
    $command1 = "msiexec.exe /I c:\temp\aderencia_6.1.0.21.msi /quiet" 
    $process = [WMICLASS]"$cmp_atu\ROOT\CIMV2:win32_process"
    $result1 = $process.Create($command1) 
    $Atualizados.Add($cmp) 
    } 
    
    else{
    $Desligados.Add($cmp)
    }
    
    }


Write-Host "Computadores Atualizados"
$Atualizados
Write-Host "Computadores Atualizados"$Atualizados.count -ForegroundColor Green
Write-Host "Computadores desligados"
$Desligados
Write-Host "Computadores Desligados"$Desligados.count -ForegroundColor Red  
