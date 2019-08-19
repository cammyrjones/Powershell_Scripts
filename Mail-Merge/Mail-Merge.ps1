# Reports on Success and Failure
$EmailDeliveryNotificationOption = "onFailure"
 
# SMTP server details
$EmailSMTPserver = "smtp.office365.com"
$Port = 587
$SMTPCred = (Get-Credential) # User format is domain\username

# Name and email of sender
$EmailFrom = "Your Name <youremail@example.com>"
 
# CSV with columns named Name, Email, SamAccountName
$SourcePath = "C:\temp\Users.csv"
 
# Imports the list of users
$Users = Import-Csv -Path $SourcePath
 
foreach ($User in $Users) {
 
# User's email address
$EmailTo = $User.Email
 
# Email subject
$EmailSubject = "A personalized example for " + $User.FirstName + " " + $User.LastName + "."

# Email Body
$EmailBody += "<p>Dear " + $User.FirstName + ":</p>"
$EmailBody += "<p>This is an example.</p>"
$EmailBody += "<p><ul><li>Your First Name: <strong>" + $User.FirstName + "</strong></li>"
$EmailBody += "<li>Your Last Name: <strong>" + $User.LastName + "</strong></li>"
$EmailBody += "<li>Your Email Address: <strong>" + $User.Email + "</strong></li></ul></p>"
$EmailBody += "<p>This is another example</p>"
$EmailBody += "<p>Kind Regards,</p>"
$EmailBody += "<p>Your Name</p>"
$EmailBody += "</body></html>"
 
# Conduct the email merge, sending emails
Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $EmailSubject -Body $EmailBody -BodyAsHtml -SmtpServer $EmailSmtpServer -Port $Port -Credential $SMTPCred -DeliveryNotificationOption $EmailDeliveryNotificationOption
}