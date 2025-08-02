
```
**Usage Example:**
```powershell
.\Check-SPN-NTLM.ps1 -ComputerName "SERVER01"
```

**Requirements:**
- Must be run with sufficient privileges to query Active Directory and remote registry.
- `Get-ADComputer` requires RSAT/ActiveDirectory module.

**Returned Object Example:**
```powershell
ComputerName   SPNRegistered NTLMDisabled
------------   ------------- ------------
SERVER01       True          True
```
Let me know if you want the script to check for specific SPNs or NTLM registry values!