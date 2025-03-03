# ----- Configurable Variables ----- #
$DOMAIN_NAME = ([ADSI]"").distinguishedName -replace ",.+", "" # Dynamically fetch the domain name
$COMPUTER_OU = "OU=Computers,DC=$($DOMAIN_NAME -replace '\.', ',DC=')" # Target OU
# ---------------------------------- #

# Prompt for domain admin credentials
$credential = Get-Credential -Message "Enter Domain Admin Credentials (Format: DOMAIN\Username)"

# Ensure the Organizational Unit exists
if (-not (Get-ADOrganizationalUnit -Filter "distinguishedName -eq '$COMPUTER_OU'" -ErrorAction SilentlyContinue)) {
    Write-Host "Creating OU for Computers: $COMPUTER_OU" -ForegroundColor Cyan
    New-ADOrganizationalUnit -Name "Computers" -Path "DC=$($DOMAIN_NAME -replace '\.', ',DC=')" -ProtectedFromAccidentalDeletion $false
}

# Get the name of the local computer
$localComputerName = $env:COMPUTERNAME
Write-Host "Detected local computer name: $localComputerName" -ForegroundColor Green

# Check if the computer account already exists in AD
$computerExists = Get-ADComputer -Filter "Name -eq '$localComputerName'" -SearchBase $COMPUTER_OU -ErrorAction SilentlyContinue

if ($computerExists) {
    Write-Host "Computer account already exists in AD: $localComputerName" -ForegroundColor Yellow
} else {
    # Create a new computer account in AD
    Write-Host "Creating computer account in AD: $localComputerName" -ForegroundColor Cyan
    try {
        New-ADComputer -Name $localComputerName `
                       -Path $COMPUTER_OU `
                       -Description "Added dynamically by script" `
                       -Enabled $true
        Write-Host "Successfully created computer account: $localComputerName" -ForegroundColor Green
    } catch {
        Write-Host "Failed to create computer account: $localComputerName" -ForegroundColor Red
        Write-Host $_.Exception.Message
        return
    }
}

# Join the local computer to the domain
try {
    Write-Host "Joining computer $localComputerName to domain $DOMAIN_NAME" -ForegroundColor Cyan
    Add-Computer -DomainName $DOMAIN_NAME -Credential $credential -OUPath $COMPUTER_OU -Restart -Force
    Write-Host "Successfully joined $localComputerName to domain $DOMAIN_NAME" -ForegroundColor Green
} catch {
    Write-Host "Failed to join computer to the domain: $localComputerName" -ForegroundColor Red
    Write-Host $_.Exception.Message
}
