# dot-source the main script
. ./get_set_filecontent.ps1
# define the file path to work on
$filepath = Read-Host "Enter output file path"
# run the commands against the given file path
Set-FileContent $filepath

pause