output "PrivateIP" {
  value = aws_instance.ec2_instance[var.InstanceName].private_ip 
  sensitive = true
}

output "AdminPass" {
  value     = null_resource.AdminPass.triggers.admin_pass
  sensitive = true
}