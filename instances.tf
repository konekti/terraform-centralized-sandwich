resource "aws_instance" "web_instances_one" {
  ami   = data.aws_ami.amazon_linux_2.id
  count = 1

  instance_type               = "t3.nano"
  associate_public_ip_address = false
  subnet_id                   = module.app-vpc.private_subnets[count.index]
  security_groups             = [module.app-vpc.default_security_group_id]

  user_data = file("user-data.sh")
  key_name  = var.ssh_key

  tags = {
    Name = "webservers",
    Role = "Backend"
  }
}

resource "aws_instance" "web_instances_two" {
  ami   = data.aws_ami.amazon_linux_2.id
  count = 1

  instance_type               = "t3.nano"
  associate_public_ip_address = false
  subnet_id                   = module.app-vpc.private_subnets[count.index]
  security_groups             = [module.app-vpc.default_security_group_id]

  user_data = file("user-data.sh")
  key_name  = var.ssh_key

  tags = {
    Name = "webservers",
    Role = "Backend"
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.????????-x86_64-gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "bastion" {
  ami = data.aws_ami.amazon_linux_2.id

  instance_type               = "t3.nano"
  associate_public_ip_address = true
  subnet_id                   = module.firewall-vpc.public_subnets[0]
  security_groups             = [module.firewall-vpc.default_security_group_id, aws_security_group.bastion.id]

  key_name = var.ssh_key
  tags = {
    Name = "bastion"
  }
}

resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "permit"
  vpc_id      = module.firewall-vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.management_prefix]
  }
}
