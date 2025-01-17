data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "architecture"
    values = ["x86_64"]
  }

  owners = ["amazon"]
}

resource "aws_security_group" "machine_access" {
  name_prefix = local.system_name

  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

resource "aws_instance" "machine" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.machine.id
  associate_public_ip_address = true

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  tags = {
    Name = local.system_name
  }

  vpc_security_group_ids = [aws_security_group.machine_access.id]
  
  key_name = "us-east-key"
  
  user_data_base64 = data.cloudinit_config.init.rendered
}



data "cloudinit_config" "init" {
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/upload_machine_data.sh",{SYSTEM_NAME=local.system_name})
    filename = "upload_machine_data.sh"
  }
}
