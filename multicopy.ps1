param(
     [Parameter()]
     [string]$IPsFile,

     [Parameter()]
     [string]$Source,

     [Parameter()]
     [string]$Destination
 )

$machinesArray = Get-Content($IPsFile)
$credential = Get-Credential

# Copy the file to each machine
# Machines must be trusted to created PSSession by IP address

$currentTrustedHosts = (get-item wsman:\localhost\Client\TrustedHosts).value

foreach ($machine in $machinesArray) {
    if ($currentTrustedHosts -ne "") {
        Set-Item wsman:\localhost\Client\TrustedHosts -value "$currentTrustedHosts, $($machine.ToString())" -Force
    } else {
        Set-Item wsman:\localhost\Client\TrustedHosts -value $machine.ToString() -Force
    }
    $session = New-PSSession -ComputerName $machine -Credential $credential
    Copy-Item -Path $Source -Destination $Destination -ToSession $session
    Remove-PSSession -Id $session.Id
}

# Restore original set of trusted hosts
Set-Item wsman:\localhost\Client\TrustedHosts -value $currentTrustedHosts -Force