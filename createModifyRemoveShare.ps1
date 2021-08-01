$servers = gc "C:\SCRIPTS\HostName.txt"
$folderName = "PoSh"
$sharename = "PShell-teste"

foreach ($server in $servers){

	#Create a New Folder
	$newFolder = New-Item -Path \\$server\C$\$folderName -name $folderName -ItemType Directory
	Write-Host "Create a Folder " $folderName "on server " $server

	#Create a new Cim Session on server
	$cims = New-CimSession -ComputerName $server
	
#To Create
	#Create a Share with permission
	New-SmbShare -Name $sharename -Path C:\PoSh\$folderName -CimSession $cims -FullAccess Administrators -ReadAccess everyone -ConcurrentUserLimit 10
	Write-Host "Create a share " $sharename "on server " $server
	
#To modify
	#Modify a share permission
	#Grant-SmbShareAccess -Name CALog -CimSession $cims -AccountName everyone -AccessRight read -Force
	#Write-Host "Modify Permission on " $sharename "on server " $server
	
#To Remove
	#Remove a Share
	#Remove-SmbShare -Name $sharename -CimSession $cims -force
	#Write-Host "Remove Share " $sharename "on server " $server

}
