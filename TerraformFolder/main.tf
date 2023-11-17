resource "random_integer" "subentnum" {
  min = 0
  max = 1
}

resource "aws_instance" "ec2_instance" {
  for_each                    = var.Configuration
  ami                         = each.value.AMI
  instance_type               = each.value.Instance_type
  vpc_security_group_ids      = [for s in data.aws_security_group.SecurityGroups : s.id]
  associate_public_ip_address = false
  key_name                    = var.KeyPair
  subnet_id                   = [for s in data.aws_subnet.subnets : s.id][random_integer.subentnum.result]
  get_password_data           = each.value.AMI == "ami-0fc682b2a42e57ca2" || each.value.AMI == "ami-0ea6a9ded5194e937" ? true : false
  tags = {
    Name = each.value.InstanceName
  }
  user_data = each.value.AMI == "ami-0fc682b2a42e57ca2" || each.value.AMI == "ami-0ea6a9ded5194e937" ? data.template_file.userdata.rendered : null

  root_block_device {
    volume_size = 100
    volume_type = "gp3"
    encrypted   = true
  }
}

resource "null_resource" "AdminPass" {
  triggers = {
    admin_pass = var.getpass ? "${rsadecrypt(aws_instance.ec2_instance[var.InstanceName].password_data, file("${var.temp_directory}/${var.KeyPair}"))}" : null
  }

  provisioner "local-exec" {
    command = "echo 'Running RSA decryption...'"
  }
  depends_on = [
    aws_instance.ec2_instance
  ]
}