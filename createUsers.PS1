###Criar Usuário em Massa###

###Variáveis Globais
$date = Get-Date
$Password = "vikstar.2021" | Convertto-SecureString -AsPlainText -Force
$NovosUsuarios = Import-Csv "C:\USER_PS\CRIACAO.csv" -Header @("cpf","nome","Sobrenome")

##Informações Espelho
$UsuarioEspelho = "100657069"
$InformacoesUsuarioEspelho = Get-ADUser -Identity $UsuarioEspelho -Properties DistinguishedName,Memberof,CN | Select-Object DistinguishedName,Memberof,CN
$MemberOfs = $InformacoesUsuarioEspelho.Memberof
$UnidadeOrganizacional = $InformacoesUsuarioEspelho.DistinguishedName -replace '^cn=.+?(?<!\\),'

##Informações Para Cadastro
"Processamento iniciado (em " + $date + "): " 
"--------------------------------------------"
foreach($NovoUsuario in $NovosUsuarios){
    $Account = $NovoUsuario.cpf
    $PrimeiroNome = $NovoUsuario.nome
    $SegundoNome = $NovoUsuario.Sobrenome
    $NomeCompleto = $PrimeiroNome +" "+ $SegundoNome
    $PrincipalName = $Account + "@vikstarsp.br"
    Write-Host "[INFO]`t Criando usuario: $($PrincipalName)"
    New-aduser -SamAccountName $Account -UserPrincipalName $PrincipalName -GivenName $PrimeiroNome -Name $NomeCompleto -Surname $SegundoNome -DisplayName $NomeCompleto -AccountPassword $Password -Path $UnidadeOrganizacional -Enabled $true -ChangePasswordAtLogon $false
    foreach($MemberOf in $MemberOfs){
    Add-ADGroupMember -Identity $MemberOf -Members $Account    
    }
    Write-Host "[INFO]`t Novo usuario criado: $($PrincipalName)"
}
"--------------------------------------------" + "`r`n"
