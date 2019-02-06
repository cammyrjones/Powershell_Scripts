# dot-source the main script
. ./get_set_filecontent.ps1
# define the file path to work on
$filepath = Read-Host "Enter input file path"
# run the commands against the given file path
Get-FileContent $filepath

pause