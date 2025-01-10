#Searching for executables that can be run as admin
function Enumerate-Files {
    #Need to get dlls as well
    Get-Childitem -Recurse -Filter *.exe -Path C:\ | ForEach-Object{
        Get-Acl -Path $_.FullName
    }
    
}

Enumerate-Files