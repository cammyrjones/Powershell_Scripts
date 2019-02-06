$ErrorActionPreference = "stop"

$installer = "d:\setup.exe"

$installargs = "/ReflectDrivers 'C:\Program Files\McAfee\Endpoint Encryption\OSUpgrade'"

Start-Process -FilePath $installer -ArgumentList $installArgs