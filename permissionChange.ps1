$GRUPO = 'GL_FINANCEIRO'


   #Setar o Grupo a ser Removido ou Adicionado

$USUARIOS = Get-Content C:\SCRIPTS\PERMISSAO.txt   #Diretorio onde buscar os CPF´s

foreach($USUARIO in $USUARIOS)
{
   ADD-ADGroupMember -Identity $GRUPO -Members $USUARIO -Confirm:$false    #Remove para remover a permissão - ADD para adicionar
   Write-Host $USUARIO
}