#TO DO - test with Win 7 - issue with symbolic links

#define list of items in user folder to exclude
$exclusionlist = @()
$exclusionlist +="AppData"
$exclusionlist +="Application Data"
$exclusionlist +="Contacts"
$exclusionlist +="Cookies"
$exclusionlist +="IntelGraphicsProfiles"
$exclusionlist +="links"
$exclusionlist +="Local Settings"
$exclusionlist +="Music"
$exclusionlist +="NetHood"
$exclusionlist +="Pictures"
$exclusionlist +="PrintHood"
$exclusionlist +="Roaming"
$exclusionlist +="Recent"
$exclusionlist +="Saved Games"
$exclusionlist +="Searches"
$exclusionlist +="SendTo"
$exclusionlist +="Start Menu"
$exclusionlist +="Templates"
$exclusionlist +="Videos"
$exclusionlist +="ntuser*"
$exclusionlist +="*.log"

#define the source path i.e. the user folder
$sourcepath = $env:USERPROFILE
#define the backup destination
$backuppath = "c:\temp\user_folder_backup\$env:USERNAME"
#define the list of folders to be copied
$folderlist = Get-Item -Path $sourcepath\* -Force -Exclude $exclusionlist
#get the size of the user's folders
$colItems = foreach ($folder in $folderlist){(Get-ChildItem $folder -recurse -ErrorAction Ignore | Measure-Object -property length -sum)}
$foldersize = ("{0:N0}" -f (($colItems.Sum | Measure-Object -Sum).Sum / 1MB))
$foldersize = [int]$foldersize


# define the settings for the force refresh prompt
$forcetitle = "Force folder backup?"
$forcemessage = "User folder contents over 1GB in size, continue?"
$forceyes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", `
    "Will force a backup of the user profile folder"
$forceno = New-Object System.Management.Automation.Host.ChoiceDescription "&No", `
    "Will exit script"
$forceoptions = [System.Management.Automation.Host.ChoiceDescription[]]($forceyes, $forceno)


function backupuserfolder
{
New-Item -Path $backuppath -ItemType Directory
#Copy-Item -Path $sourcepath -Recurse -Destination $backuppath #-WhatIf
foreach ($folder in $folderlist)
    {
    Copy-Item -Path $folder -Recurse -Destination $backuppath #-WhatIf
    }
}


if ($foldersize -gt [int]1024)
{
 # inform user that the folder contents are greater than 1GB and give them a choice of what to do
    $forceresult = $host.ui.PromptForChoice($forcetitle, $forcemessage, $forceoptions, 1) 
    switch ($forceresult)
    {
        #if yes is picked
        0 
        {
            & backupuserfolder
        }
        
        # if no is picked    
        1
        {
            Write-Host "Exiting..."
            Start-Sleep -Seconds 2
            exit
        }
    }
}
else
{
& backupuserfolder
}