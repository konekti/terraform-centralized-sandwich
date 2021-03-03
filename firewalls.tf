resource "aws_network_interface" "firewall1_trust_eni" {
  subnet_id         = module.firewall-vpc.private_subnets[0]
  security_groups   = [aws_security_group.firewall_mgmt.id, module.firewall-vpc.default_security_group_id]
  private_ips_count = 1
  private_ips       = ["172.17.100.10"]

  tags = {
    Name = "firewall1_trust_eni"
  }
}

resource "aws_network_interface" "firewall2_trust_eni" {
  subnet_id         = module.firewall-vpc.private_subnets[1]
  security_groups   = [aws_security_group.firewall_mgmt.id, module.firewall-vpc.default_security_group_id]
  private_ips_count = 1
  private_ips       = ["172.17.101.10"]
  tags = {
    Name = "firewall2_trust_eni"
  }
}

resource "aws_network_interface" "firewall1_untrust_eni" {
  subnet_id         = module.firewall-vpc.public_subnets[0]
  security_groups   = [aws_security_group.firewall.id]
  source_dest_check = false
  private_ips_count = 1
  private_ips       = ["172.17.0.50"]

  tags = {
    Name = "firewall1_untrust_eni"
  }
}

resource "aws_network_interface" "firewall2_untrust_eni" {
  subnet_id         = module.firewall-vpc.public_subnets[1]
  security_groups   = [aws_security_group.firewall.id]
  source_dest_check = false
  private_ips_count = 1
  private_ips       = ["172.17.1.50"]

  tags = {
    Name = "firewall2_untrust_eni"
  }
}

resource "aws_instance" "firewall1" {

  ami           = "ami-0e287dd3d384b7525"
  instance_type = "t3.nano"
  key_name      = var.ssh_key

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.firewall1_untrust_eni.id
  }

  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.firewall1_trust_eni.id
  }

  tags = {
    Name = "firewall1"
  }
}

resource "aws_instance" "firewall2" {

  ami           = "ami-0e287dd3d384b7525"
  instance_type = "t3.nano"
  key_name      = var.ssh_key


  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.firewall2_untrust_eni.id
  }

  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.firewall2_trust_eni.id
  }

  tags = {
    Name = "firewall2"
  }
}

resource "aws_security_group" "firewall" {
  name        = "firewall"
  description = "permit all for firewall"
  vpc_id      = module.firewall-vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "firewall_mgmt" {
  name        = "firewall management"
  description = "Permit SSH to firewall from VPC"
  vpc_id      = module.firewall-vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.17.0.0/16"]
  }
}

data "template_file" "firewall1_config" {
  depends_on = [aws_lb.alb]
  template   = file("firewall-config.tpl")
  vars = {
    hostname                  = "firewall1"
    trust_ip                  = "172.17.100.10"
    untrust_ip                = "172.17.0.50"
    untrust_implied_router_ip = "172.17.0.1"
    trust_implied_router_ip   = "172.17.100.1"
    app_vpc_cidr              = "172.18.0.0/16"
    alb_ip                    = "x.x.x.x"
  }
}

data "template_file" "firewall2_config" {
  depends_on = [aws_lb.alb]
  template   = file("firewall-config.tpl")
  vars = {
    hostname                  = "firewall2"
    trust_ip                  = "172.17.101.10"
    untrust_ip                = "172.17.1.50"
    untrust_implied_router_ip = "172.17.1.1"
    trust_implied_router_ip   = "172.17.101.1"
    app_vpc_cidr              = "172.18.0.0/16"
    alb_ip                    = "y.y.y.y"
  }
}


