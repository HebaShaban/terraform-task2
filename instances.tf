data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
resource "aws_instance" "public-instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnets["public"].id
  vpc_security_group_ids      = [aws_security_group.pub-security-group.id]
  associate_public_ip_address = true
  source_dest_check           = false
  user_data = <<-EOF
   #!/bin/bash
    sudo apt update
    sudo apt install -y apache2
  EOF
  
  tags = { 
    Name = "public-instance" 
    }
}
resource "aws_instance" "private-instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnets["private"].id
  vpc_security_group_ids      = [aws_security_group.private-security-group.id]
  associate_public_ip_address = false
  user_data = <<-EOF
   #!/bin/bash
    sudo apt update
    sudo apt install -y apache2
  EOF
  
  tags = { Name = "private-instance" }
}

