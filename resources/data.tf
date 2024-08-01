data "aws_ami" "ami" {
  most_recent      = true
  name_regex       = "Centos-8-DevOps-Practice"
  owners           = [973714476881]
}
data "aws_subnet" "subnet2" {
  id = var.subnet2
}
variable "subnet2" {
  default = "subnet-0ff6271919fded4cf"
}
variable "security_group_id" {
  default = "sg-077c0e51f082021e6"
}
data "aws_security_group" "ig" {
  id = var.security_group_id
}
variable "requester_vpc" {
  default = "vpc-0683db6837f2e22a0"
}
data "aws_vpc" "requester_vpc" {
  id = var.requester_vpc
}
variable "acceper_vpc" {
  default = "vpc-061278f187529b139"
}
data "aws_vpc" "acceper_vpc" {
  id = var.acceper_vpc
}