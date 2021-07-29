$Comp = Read-Host “Digite o nome do Servidor”
Write-Host Tipos de verificação:
Write-Host 1 – Para verificar o status de todos os serviços;
Write-Host 2 – Para verificar os serviços que estão rodando;
Write-Host 3 – Para verificar os serviços que estão parados;
Write-Host 4 – Para verificar os serviços que estão parados e tem inicialização automática;
Write-Host 5 – Para digitar o nome do serviço a ser verificado;
$vertype = Read-Host “Digite o tipo de verificação”
$UserName = Read-Host “Enter User Name”
$Password = Read-Host -AsSecureString “Enter Your Password”
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $UserName , $Password
if ($vertype -eq 1)
{
$Service = Get-WmiObject -Class Win32_Service -ComputerName $Comp -Credential $Credential
$Service
}
elseif ($vertype -eq 2)
{
$Service = Get-WmiObject -Class Win32_Service -ComputerName $Comp -Credential $Credential
$Service | where state -eq “running” | format-table -property name, state
}
elseif ($vertype -eq 3)
{
$Service = Get-WmiObject -Class Win32_Service -ComputerName $Comp -Credential $Credential
$Service | where state -eq “stopped” | format-table -property name, state
}
elseif ($vertype -eq 4)
{
$Service = Get-WmiObject -Class Win32_Service -ComputerName $Comp -Credential $Credential
$Service | where startmode -eq “auto” | where state -eq “stopped” | format-table -property name, state
}
elseif ($vertype -eq 5)
{
$Service = Read-Host “Digite o nome do Serviço”
$Service2 = Get-WmiObject -Class Win32_Service -ComputerName $Comp -Credential $Credential | where name -eq $service
$service2
}
else
{
Write-Host “Opção inválida”; exit
}