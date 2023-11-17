data "aws_security_group" "SecurityGroups" {
  for_each = toset(["CRB-Standards", "ServiceNow", "CA-Certificates", "CRB-SCCM"])
  name     = each.value
}

data "aws_subnets" "subnet" {
  tags = {
    Name = "*subnet*"
  }
}

data "aws_subnet" "subnets" {
  for_each = toset(data.aws_subnets.subnet.ids)
  id       = each.value
}

data "template_file" "userdata"{
  template = <<EOF
<powershell>
set-netconnectionprofile -networkcategory private
tzutil /s "Eastern Standard Time"
$hostIP=(Get-NetAdapter| Get-NetIPAddress).IPv4Address|Out-String
$hostname = $env:COMPUTERNAME
$srvCert = New-SelfSignedCertificate -DnsName $hostname,$hostIP -CertStoreLocation Cert:\LocalMachine\My
New-Item -Path WSMan:\localhost\Listener\ -Transport HTTPS -Address * -CertificateThumbPrint $srvCert.Thumbprint -Force
New-NetFirewallRule -DisplayName "Allow WinRM HTTPS" -Direction Inbound -LocalPort 5986 -Protocol TCP -Action Allow
</powershell>
EOF
}
