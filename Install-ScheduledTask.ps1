$TaskName = "Task Name"
$TaskAction = "C:\Path\to\Program.exe"
$TaskArgument = ""

$Schedule = New-Object -com Schedule.Service
$Schedule.connect()
$Tasks = $Schedule.GetFolder("\").GetTasks(0)

$TaskExists = Get-ScheduledTask | Where-Object {$_.TaskName -like $TaskName}

if(-not $TaskExists){
    Write-Host "Creating task..." -ForegroundColor Cyan
	$action = New-ScheduledTaskAction -Execute $TaskAction -Argument $TaskArgument
    $trigger = New-ScheduledTaskTrigger -Daily -At 12am
    $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType S4U -RunLevel Highest
    $settings = New-ScheduledTaskSettingsSet -MultipleInstances Parallel

    Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -Settings $settings -Principal $principal
    Write-Host "Created task..." -ForegroundColor Cyan
} else {
    Write-Host "Task already exists" -ForegroundColor Cyan
}