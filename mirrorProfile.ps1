    $_ESPELHO = "056619063" #ADICIONAR AQUI O USUARIO ESPELHO
    $InformacoesUsuarioEspelho = Get-ADUser -Identity $_ESPELHO -Properties DistinguishedName,Memberof,CN | Select-Object DistinguishedName,Memberof,CN
    $EspelhoMemberOfs = $InformacoesUsuarioEspelho.Memberof
    $UnidadeOrganizacional = $InformacoesUsuarioEspelho.DistinguishedName -replace '^cn=.+?(?<!\\),'

    $USUARIOS = Get-Content C:\SCRIPTS\ESPELHAMENTO.txt # CRIAR PASTA E TXT NO CAMINHO SELECIONADO PARA NÃO PRECISAR MUDAR O CODIGO
    foreach($USUARIO in $USUARIOS){
        ##Remover Grupos
          
            $grupos = Get-ADPrincipalGroupMembership -Identity $USUARIO | Select-Object Name,SID | Where-Object {$_.SID -notlike 'S-1-5-21-82475451-829243538-3981570914-513' }  # SELECIONA OS GRUPOS
            foreach ($grupo in $grupos)                                                                          
            {        
                Remove-ADGroupMember -confirm:$false -Identity $grupo.SID -Members $USUARIO  # REMOVE TODOS OS GRUPOS COM * \\USUARIOS DO DOMINIO NÃO REMOVE POR ISSO OS ERROS APRESENTADOS * 
            }

    # ADICIONA GRUPOS DO PERFIL ESPELHO IDENTIFICADO

            Foreach($GroupAdd in $EspelhoMemberOfs){
                Add-ADGroupMember -Identity $GroupAdd -Members $USUARIO      # ADICIONA GRUPOS DO PERFIL ESPELHO IDENTIFICADO
                $GroupAdd
                $USUARIO  
        
             }                                        
         
       Get-ADUser $USUARIO | Move-ADObject -TargetPath "$UnidadeOrganizacional"
       Get-ADUser -Identity $USUARIO | Select-Object SamAccountName,Name,DistinguishedName

}