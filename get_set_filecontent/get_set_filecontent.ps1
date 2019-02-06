# define the function of get-filecontent
function Get-FileContent($filePath) 
{ 
     $command = 
     { 
         
         # add assembly names
         Add-Type -an System
         Add-Type -an System.Windows.Forms
         # $filepatharg defined by the first argument passed to function IE the file path 
         $filePathArg = $Args[0]
         # $content defined by reading all the bytes of the file path
         $content = [System.IO.File]::ReadAllBytes($filePathArg)
         # $encoded defined by converting $content to a base64 encoded string
         $encoded = [System.Convert]::ToBase64String($content)
         # set the text on the clipboard to be the value of $encoded
         [System.Windows.Forms.Clipboard]::SetText($encoded)
     } 
     # run the command
     powershell -sta -noprofile -args $filePath -command $command
}

#define the function of set-filecontent
function Set-FileContent($filePath) 
{ 
     $command = 
     { 
         # add assembly names
         Add-Type -an System
         Add-Type -an System.Windows.Forms
         # filepatharg defined by the first argument passed to function IE the file path  
         $filePathArg = $Args[0]
         # $encoded defined by getting the value of the string on the clipboard
         $encoded = [System.Windows.Forms.Clipboard]::GetText()
         # try/catch block to convert the value of $encoded from base64, on failure will break
         try {
         $content = [System.Convert]::FromBase64String($encoded)
         } catch [FormatException] {
          Write-Error "CONVERT FROM BASE64 FAILED!!! Clipboard may not be ready"
          break
         }
         # if it worked, it will write out the file contents based on variables above  
         [System.IO.File]::WriteAllBytes($filePathArg, $content)
     } 
     # run the command
     powershell -sta -noprofile -args $filePath -command $command
}

