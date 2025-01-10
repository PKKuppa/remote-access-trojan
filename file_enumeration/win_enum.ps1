#Searching for executables that can be run as admin
function Enumerate-Files {
    #Need to get dlls as well
    #Need to filter by
    $exec = @()
    Get-Childitem -Recurse -Filter *.exe -Path C:\ -ErrorAction SilentlyContinue | ForEach-Object{

       try{ $acl = Get-Acl -Path $_.FullName} catch{$acl = "Permission Denied"}
        #Need to parse acl
    }
    
    
}

Enumerate-Files