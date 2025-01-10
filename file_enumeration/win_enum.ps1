
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
    #Need to get dlls as well
    #Need to filter by
    Write-Host ""
    $exec = @()
    Get-Childitem -Recurse -Filter *.exe -Path C:\ -ErrorAction SilentlyContinue | ForEach-Object{

       try{ $acl = Get-Acl -Path $_.FullName
    } catch{$acl = $null}
       If($acl){
            Write-Host $acl.Owner
       }
    }
    
    
}

function Enumerate-Registry{
    Get-ChildItem -Path HKLM:\SAM
}



Print-Header
Print-Divider DarkYellow
Write-Host -ForegroundColor Green "====================================== Enumerating Files with Interesting Permissions ======================================"
#Enumerate-Files
Write-Host -ForegroundColor Green "====================================== Enumerating Windows Registry ========================================================"
Enumerate-Registry





