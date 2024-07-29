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