resource "aws_vpc" "vpc_2" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc_2"
  }
}
resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.vpc_2.id
  cidr_block = "10.0.0.0/17"
  tags = {
    Name = "subnet1"
  }
}
resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.vpc_2.id
  cidr_block = "10.0.128.0/17"
  tags = {
    Name = "subnet2"
  }
}
resource "aws_internet_gateway" "igw2" {
  vpc_id = aws_vpc.vpc_2.id
  tags = {
    Name = "igw2"
  }
}

resource "aws_route_table" "internet_route_table" {
  vpc_id = aws_vpc.vpc_2.id
}
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc_2.id
}
resource "aws_route_table_association" "internet" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.internet_route_table.id
}

resource "aws_security_group" "sg-allow-all" {
  name        = "sg-allow-all"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc_2.id

  tags = {
    Name = "sg-allow-all"
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.sg-allow-all.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol = "-1"
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.sg-allow-all.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}