# Retrieve the current domain's distinguished name
$domainDN = ([ADSI]"").distinguishedName

# Define department Organizational Units
$departments = @(
    "OU=Finance,OU=_USERS,$domainDN",
    "OU=IT,OU=_USERS,$domainDN",
    "OU=Marketing,OU=_USERS,$domainDN",
    "OU=HR,OU=_USERS,$domainDN",
    "OU=Production,OU=_USERS,$domainDN",
    "OU=Logistics,OU=_USERS,$domainDN"
)

# Ensure department OUs exist
foreach ($department in $departments) {
    $ouName = ($department.Split(",")[0].Split("=")[1])
    $parentPath = "OU=_USERS,$domainDN"
    if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$ouName'" -SearchBase $parentPath -ErrorAction SilentlyContinue)) {
        Write-Host "Creating OU: $ouName" -ForegroundColor Cyan
        New-ADOrganizationalUnit -Name $ouName -Path $parentPath -ProtectedFromAccidentalDeletion $false
    }
}

# Retrieve all users in the _USERS OU
$users = Get-ADUser -Filter * -SearchBase "OU=_USERS,$domainDN"

# Randomly assign each user to a department
foreach ($user in $users) {
    # Select a random department
    $randomDepartment = Get-Random -InputObject $departments

    # Move the user to the selected department OU
    Write-Host "Moving user $($user.SamAccountName) to $randomDepartment" -ForegroundColor Green
    Move-ADObject -Identity $user.DistinguishedName -TargetPath $randomDepartment
}
