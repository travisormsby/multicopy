param(
     [Parameter()]
     [string]$IPsFile,

     [Parameter()]
     [string]$Source,

     [Parameter()]
     [string]$Destination
 )

$machinesArray = Get-Content($IPsFile)
$machinesString = $machinesArray -join ", "
$credential = Get-Credential

# Machines must be trusted to created PSSession by IP address
$currentTrustedHosts = (get-item wsman:\localhost\Client\TrustedHosts).value
if ($currentTrustedHosts -ne "") {
    Set-Item wsman:\localhost\Client\TrustedHosts -value "$currentTrustedHosts, $machinesString" -Force
} else {
    Set-Item wsman:\localhost\Client\TrustedHosts -value $machinesString -Force
}

# Copy the file to each machine
foreach ($machine in $machinesArray) {
    $session = New-PSSession -ComputerName $machine -Credential $credential
    Copy-Item -Path $Source -Destination $Destination -ToSession $session
}

# Restore original set of trusted hosts
Set-Item wsman:\localhost\Client\TrustedHosts -value $currentTrustedHosts -Force