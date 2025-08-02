param(
    [Parameter(Mandatory=$true)]
    [string]$ComputerName
)

# Helper function to check SPNs
function Get-SPNStatus {
    param(
        [string]$ComputerName
    )
    try {
        $spns = (Get-ADComputer -Identity $ComputerName -Properties ServicePrincipalName).ServicePrincipalName
        if ($spns -and $spns.Count -gt 0) {
            return $true
        } else {
            return $false
        }
    } catch {
        Write-Warning "Could not query SPNs for $ComputerName: $_"
        return $null
    }
}

# Helper function to check NTLM status
function Get-NTLMStatus {
    param(
        [string]$ComputerName
    )
    try {
        $regPaths = @(
            'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa'
        )
        $ntlmDisabled = $false

        foreach ($regPath in $regPaths) {
            $key = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                param($Path)
                Get-ItemProperty -Path $Path -ErrorAction SilentlyContinue
            } -ArgumentList $regPath -ErrorAction SilentlyContinue

            if ($null -ne $key) {
                # Check for "LmCompatibilityLevel" (5 disables NTLMv1/v2 in most configs)
                if ($key.LmCompatibilityLevel -ge 5) {
                    $ntlmDisabled = $true
                }
            }
        }
        return $ntlmDisabled
    } catch {
        Write-Warning "Could not query NTLM status for $ComputerName: $_"
        return $null
    }
}

# Collect Results
$result = [PSCustomObject]@{
    ComputerName = $ComputerName
    SPNRegistered = Get-SPNStatus -ComputerName $ComputerName
    NTLMDisabled  = Get-NTLMStatus -ComputerName $ComputerName
}

return $result