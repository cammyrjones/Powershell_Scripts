$adOpenStatic = 3
$adLockOptimistic = 3

$conn=New-Object -com "ADODB.Connection"
$rs = New-Object -com "ADODB.Recordset"
$conn.Open('Provider=Microsoft.ACE.OLEDB.12.0;Data Source="C:\temp\asset_db\Fortek In-House Asset Manager.mdb" ;Persist Security Info=True;')

$rs.Open("SELECT * FROM tblhardware",$conn,$adOpenStatic,$adLockOptimistic)

$rs.MoveFirst()
While ($rs.EOF -ne $True)
{
    <#ForEach ($column in "URN", "Purchased") {
        $rs.Fields.Item("$column").Value    
    }
    #>
    ($rs.Fields.Item("URN").Value) +"," + ($rs.Fields.Item("Purchased").Value) +"," + ($rs.Fields.Item("Warranty Expires").Value)|Out-File "C:\temp\asset_db\output.csv" -Append -NoClobber 
    $rs.MoveNext()
}


$conn.Close
$rs.Close