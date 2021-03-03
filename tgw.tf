resource "aws_ec2_transit_gateway" "tgw" {
  auto_accept_shared_attachments = "enable"

  tags = {
    Name = "terraform-tgw"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "firewall-vpc" {
  subnet_ids                                      = module.firewall-vpc.private_subnets
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw.id
  vpc_id                                          = module.firewall-vpc.vpc_id
  transit_gateway_default_route_table_association = false

  tags = {
    Name = "firewall-vpc"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "app-vpc" {
  subnet_ids                                      = module.app-vpc.private_subnets
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw.id
  vpc_id                                          = module.app-vpc.vpc_id
  transit_gateway_default_route_table_association = false

  tags = {
    Name = "app-vpc"
  }
}

resource "aws_ec2_transit_gateway_route_table" "firewall-vpc" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id

  tags = {
    Name = "firewall-vpc"
  }
}

resource "aws_ec2_transit_gateway_route_table" "app-vpc" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id

  tags = {
    Name = "app-vpc"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "firewall-vpc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.firewall-vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.firewall-vpc.id
}

resource "aws_ec2_transit_gateway_route_table_association" "app-vpc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.app-vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.app-vpc.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "firewall-vpc-one" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.firewall-vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.firewall-vpc.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "firewall-vpc-two" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.app-vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.firewall-vpc.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "app-vpc-one" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.app-vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.app-vpc.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "app-vpc-two" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.firewall-vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.app-vpc.id
}

resource "aws_route" "app-vpc-one" {
  route_table_id         = module.firewall-vpc.private_route_table_ids[0]
  destination_cidr_block = module.app-vpc.vpc_cidr_block
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}

resource "aws_route" "app-vpc-two" {
  route_table_id         = module.firewall-vpc.private_route_table_ids[1]
  destination_cidr_block = module.app-vpc.vpc_cidr_block
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}

resource "aws_route" "firewall-vpc-one" {
  route_table_id         = module.app-vpc.private_route_table_ids[0]
  destination_cidr_block = module.firewall-vpc.vpc_cidr_block
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}

resource "aws_route" "firewall-vpc-two" {
  route_table_id         = module.app-vpc.private_route_table_ids[1]
  destination_cidr_block = module.firewall-vpc.vpc_cidr_block
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}
