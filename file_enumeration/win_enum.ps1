
function Print-Header{
    # Define the ASCII art in a variable
$asciiArt = @"
 ________      ________      _________        _______       ________       ___  ___      _____ ______      
|\   __  \    |\   __  \    |\___   ___\     |\  ___ \     |\   ___  \    |\  \|\  \    |\   _ \  _   \    
\ \  \|\  \   \ \  \|\  \   \|___ \  \_|     \ \   __/|    \ \  \\ \  \   \ \  \\\  \   \ \  \\\__\ \  \   
 \ \   _  _\   \ \   __  \       \ \  \       \ \  \_|/__   \ \  \\ \  \   \ \  \\\  \   \ \  \\|__| \  \  
  \ \  \\  \|   \ \  \ \  \       \ \  \       \ \  \_|\ \   \ \  \\ \  \   \ \  \\\  \   \ \  \    \ \  \ 
   \ \__\\ _\    \ \__\ \__\       \ \__\       \ \_______\   \ \__\\ \__\   \ \_______\   \ \__\    \ \__\
    \|__|\|__|    \|__|\|__|        \|__|        \|_______|    \|__| \|__|    \|_______|    \|__|     \|__|
"@

# Write the ASCII art to the console
Write-Host $asciiArt -ForegroundColor Cyan
Write-Host ""
}
function Print-Divider{
    [CmdletBinding()]
    param(
        [System.ConsoleColor]$Color
    )
$asciiArt = @"
============================================================================================================================
============================================================================================================================
============================================================================================================================
"@

Write-Host $asciiArt -ForegroundColor $Color
Write-Host ""

}

#Searching for executables that can be run as admin
function Enumerate-Files {

    #Also filter by admin or system ownership
    $directories = @("\Windows\System32", "\Program Files", "\Program Files (x86)", "\Windows\Temp")
    Write-Host ""
    $exec = @()
    $riskyPermissions = @(
        "WriteData", "AppendData", "WriteAttributes", "WriteExtendedAttributes",
        "Delete", "WriteOwner", "WriteDacl", "TakeOwner", "FullControl"
    )

    foreach($dir in $directories){
    Get-Childitem  -Filter *.exe -Path $dir -ErrorAction SilentlyContinue | ForEach-Object{
        $fullPath = $_.FullName
       try{ $acl = Get-Acl -Path $fullPath
    } catch{$acl = $null}
       If($acl){
        $owner = $acl.Owner
        $group = $acl.Group
        foreach($Access in $acl.Access){
            $identity = $Access.IdentityReference
            $permissions = $Access.FileSystemRights.ToString().Split(", ")
            $allow = $Access.AccessControlType

            $isRisky = #(($owner -contains "Administrator" -or $group -contains "Administrator") -or ($owner -contains "System" -or $group -contains "System")) -and 
            ($permissions | Where-Object {$riskyPermissions -contains $_ }) 

            if($isRisky){
                $exec += 
                    [PSCustomObject]@{
                        Path = $fullPath
                        Identity = $identity
                        Permissions = $permissions
                        Allow = $allow
                        Owner = $owner
                        Group = $group
                    }
                }
            }
        }
        }    
       }
       if($exec.Count -eq 0){
        Write-Host "No interesting file permissions found ...." -ForegroundColor Cyan
       }
       else{
        $exec | Format-Table -AutoSize
        #Write-Host $exec -ForegroundColor Yellow
       }
    }
    

function Enumerate-Registry{
    $antivirus = @()
    Get-ChildItem -Path HKLM:\Software | ForEach-Object{

    }
}



Print-Header
Print-Divider DarkYellow
Write-Host -ForegroundColor Green "====================================== Enumerating Files with Interesting Permissions ======================================"
Enumerate-Files
Write-Host -ForegroundColor Green "====================================== Enumerating Windows Registry ========================================================"
#Enumerate-Registry





