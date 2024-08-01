resource "aws_vpc" "vpc-1" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc-1"
  }
}
resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.vpc-1.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "subnet1"
  }
}
resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.vpc-1.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "subnet2"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc-1.id
  tags = {
    Name = "igw"
  }
}
resource "aws_route_table" "internet-route-table" {
  vpc_id = aws_vpc.vpc-1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "internet-route-table"
  }
}
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.vpc-1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw.id
  }
}
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.internet-route-table.id
}
resource "aws_route_table_association" "b" {
  subnet_id = data.aws_subnet.subnet2.id
  route_table_id = aws_route_table.private-route-table.id
}
resource "aws_security_group" "allow-all-sg" {
  name        = "allow-all-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc-1.id

  tags = {
    Name = "allow-all-sg"
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow-all-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow-all-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
resource "aws_eip" "lb" {
  domain   = "vpc"
}
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.lb.id
  subnet_id     = aws_subnet.subnet1.id
  tags = {
    Name = "nat-gw"
  }
  depends_on = [aws_internet_gateway.igw]
}
resource "aws_instance" "private_instance_1" {
  ami = data.aws_ami.ami.id
  instance_type = "t3.micro"
  subnet_id = data.aws_subnet.subnet2.id
  security_groups = [data.aws_security_group.ig.id]
}

###################VPC_PEERING#################
resource "aws_vpc_peering_connection" "foo" {
  peer_owner_id = data.aws_caller_identity.current.account_id
  peer_vpc_id   = data.aws_vpc.acceper_vpc.id
  vpc_id        = data.aws_vpc.requester_vpc.id
  peer_region = "us-east-1"
  tags = {
    Name = "VPC Peering between namelessvpc() and vpc1"
  }
  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}
