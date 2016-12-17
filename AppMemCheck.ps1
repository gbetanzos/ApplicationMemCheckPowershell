[cmdletbinding()]
param(
  $ComputerName=$env:COMPUTERNAME,
  $ProcessName="Application"
)
$LogFile = 'C:\Scripts\AppMemCheck.log'
"------------------------------"| Out-File $LogFile -Append -Force
Get-Date -Format "dd-MM-yyyyTH:mm:ss" | Out-File $LogFile -Append -Force
"------------------------------"| Out-File $LogFile -Append -Force
$MemLimit=300000
$process=Get-Process $ProcessName | Select-Object *
$MemorySize=$process.WorkingSet64/1024
$Executablepath = "C:\Program Files\Path\To\Application.exe"
$id= $process.Id
"Memory Size $MemorySize KB of $ProcessName" | Out-File $LogFile -Append -Force
 
if($MemorySize -gt $MemLimit){
    "$ProcessName Id - $id at $Executablepath surpases memory limit $MemLimit KB" | Out-File $LogFile -Append -Force
	"STOPPING $ProcessName " | Out-File $LogFile -Append -Force
    Stop-Process -Name $ProcessName
    Start-Sleep -s 5
    "STARTING $ProcessName" | Out-File $LogFile -Append -Force
    Start-Process -FilePath $Executablepath
}else{
    "DOING NOTHING $ProcessName Id - $id at $Executablepath - $ProcessName doesn't surpasses memory limit" | Out-File $LogFile -Append -Force
    if($id -gt 0){
        "PROCESS EXISTS $ProcessName Id - $id at $Executablepath" | Out-File $LogFile -Append -Force
    }else{
        "PROCESS DOESNT EXIST - STARTING $ProcessName" | Out-File $LogFile -Append -Force
        Start-Process -FilePath $Executablepath
    }
}
