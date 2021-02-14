$currentUserPathVar = [System.Environment]::GetEnvironmentVariable('PATH', [System.EnvironmentVariableTarget]::User)
$currentUserPathVar += "C:\Program Files (x86)\VMware\VMware Workstation;"
[System.Environment]::SetEnvironmentVariable('PATH', $currentUserPathVar, [System.EnvironmentVariableTarget]::User)
echo 'Updated environment var is :'
[System.Environment]::GetEnvironmentVariable('PATH', [System.EnvironmentVariableTarget]::User)