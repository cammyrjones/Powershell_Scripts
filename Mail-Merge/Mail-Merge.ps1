# Blanks details
$user.Email = ""
$user.FirstName = ""
$user.LastName = ""
$EmailBody = ""

# Reports on Success and Failure
$EmailDeliveryNotificationOption = "OnFailure"
 
# SMTP server details
$EmailSMTPserver = "outlook.office365.com"
$Port = 587
#$SMTPCred = (Get-Credential) # User format is domain\username or email address

# Name and email of sender
$EmailFrom = "Peter Browning <peter.browning@lakecm.co.uk>"
 
# CSV with columns named Name, Email, SamAccountName
$SourcePath = "C:\temp\Users.csv"
 
# Imports the list of users
$Users = Import-Csv -Path $SourcePath
 
foreach ($User in $Users) {
 
# User's email address
$EmailTo = $User.Email
 
# Email subject
$EmailSubject = "A Test Email for " + $User.FirstName + " " + $User.LastName + "."

# Email Body
$EmailBody = "<title>" + $EmailSubject + "</title>"
$EmailBody += "</head><body bgcolor=""#FFFFFF"" style=""font-family: sans-serif; color: #000000"">"
$EmailBody += "<p>Dear " + $User.FirstName + ":</p>"
$EmailBody += "<p>This is a test email.</p>"
$EmailBody += "<p><ul><li>Your First Name: <strong>" + $User.FirstName + "</strong></li>"
$EmailBody += "<li>Your Last Name: <strong>" + $User.LastName + "</strong></li>"
$EmailBody += "<li>Your Email Address: <strong>" + $User.Email + "</strong></li></ul></p>"
$EmailBody += "<p>The data above has been taking from a csv.</p>"
$EmailBody += "<p>Sincerely,</p>"
$EmailBody += "<p>Your Name</p>"
$EmailBody += "</body></html>"

# Conduct the email merge, sending emails
Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $EmailSubject -Body $EmailBody -BodyAsHtml -SmtpServer $EmailSMTPserver -UseSsl -Port $Port -Credential $SMTPCred -DeliveryNotificationOption $EmailDeliveryNotificationOption
}