
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
    #TODO: Instead of enumerating from root, enumerate certain directories like system32
    #Also filter by admin or system ownership
    Write-Host ""
    $exec = @()
    $riskyPermissions = @(
        "WriteData", "AppendData", "WriteAttributes", "WriteExtendedAttributes",
        "Delete", "WriteOwner", "WriteDacl", "TakeOwner", "FullControl"
    )
    Get-Childitem -Recurse -Depth 1 -Filter *.exe -Path C:\ -ErrorAction SilentlyContinue | ForEach-Object{

       try{ $acl = Get-Acl -Path $_.FullName
    } catch{$acl = $null}
       If($acl){
        $owner = $acl.Owner
        $group = $acl.Group
        foreach($Access in $acl.Access){
            $identity = $Access.IdentityReference
            $permissions = $Access.FileSystemRights.ToString().Split(", ")
            $allow = $Access.AccessControlType

            $isRisky = ($identity -notlike "Administrators") -and ($permissions | Where-Object {$riskyPermissions -contains $_ }) 
            if($isRisky){
                $exec += 
                    [PSCustomObject]@{
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
       if($exec.Count -eq 0){
        Write-Host "No interesting file permissions found ...." -ForegroundColor Cyan
       }
       else{
        $exec | Format-Table -AutoSize
        #Write-Host $exec -ForegroundColor Yellow
       }
    }

function Find-Credentials{
$emailRegex = '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'
# $credRegex = "([a-z][^\W_]{7,14}/i)|((?=[^a-z]*[a-z])(?=\D*\d)[^:&.~\s]{5,20})"
$emails = @()
$credentials = @()
$filetypes = @("*.txt","*.dat", "*.php", "*.config", "*.html")
 Get-ChildItem -Path \Users\gasprobs\Desktop -Recurse  -Depth 1 -Include $filetypes -ErrorAction SilentlyContinue | ForEach-Object{
    $fullPath = $_.FullName
    $emailMatches = Select-String -Pattern $emailRegex -Path $fullPath -AllMatches
    # $credMatches = Select-String -Pattern $credRegex -Path $fullPath -AllMatches
    if($emailMatches.Matches.Count -gt 0){
        $emailMatches.Matches | % {
            $emails += [PSCustomObject]@{
                Email = $_
                Path = $fullPath

            }
        }
    }
    # if($credMatches.Matches.Count -gt 0){
    #     $credMatches.Matches | % {
    #         $credentials += [PSCustomObject]@{
    #             Credential = $_
    #             Path = $fullPath

    #         }
    #     }
    # }
    
 }
#  $credentials | Format-Table -AutoSize
 $emails | Format-Table -AutoSize
}

#User Prompt to select enumeration options
function Enum-Prompt{
    $outfile = $null
    Print-Header
    while($true){
    
    #Print-Divider DarkYellow
    Write-Host "1. Enumerate Files" -ForegroundColor Yellow
    Write-Host "2. Find Credentials" -ForegroundColor Yellow
    Write-Host "3. Enumerate Registry" -ForegroundColor Yellow
    Write-Host "4. Run All" -ForegroundColor Yellow
    Write-Host "5. Set output file(Current Outfile: $outfile)" -ForegroundColor Yellow
    Write-Host "0. Exit" -ForegroundColor Yellow
    $option = Read-Host -Prompt "Select Option(0-4) "
    #make outfile option
    switch($option){
        0  {Write-Host "Thank You! Come again!" -ForegroundColor Magenta
            exit}
        1 {if($outfile){Enumerate-Files >> $outfile} 
    else {Enumerate-Files}}
        2 {if($outfile){Find-Credentials | Tee-Object -FilePath $outfile} 
        else {Find-Credentials}}
        3 {if($outfile){Enumerate-Registry >> $outfile} 
        else {Enumerate-Registry}}
        4 {
            #Spit to outfile

        }
        5{
           $outfile = Read-Host -Prompt "Enter the name of the output file"
        }
        default {
           $option =  Write-Host "Please enter a number from 0-4" -ForegroundColor Red
        }

    }
}
}

function Enumerate-Registry{
    $antivirus = @()
    Get-ChildItem -Path HKLM:\Software | ForEach-Object{

    }
}



# Print-Header
# Print-Divider DarkYellow
# Write-Host -ForegroundColor Green "====================================== Enumerating Files with Interesting Permissions ======================================"
# Enumerate-Files
# Write-Host -ForegroundColor Green "====================================== Enumerating Windows Registry ========================================================"
#Enumerate-Registry
# Write-Host -ForegroundColor Green "====================================== Harvesting Credentials =============================================================="
# Find-Credentials
Enum-Prompt



