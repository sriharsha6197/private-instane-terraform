data "aws_ami" "ami" {
  most_recent      = true
  owners           = 973714476881
}
data "aws_subnet" "subnet2" {
  id = var.subnet2
}
variable "subnet2" {
  default = "subnet-099626c70b91fce83"
}
data "aws_security_groups" "ig_sg" {
  id = var.security_group_id
}
variable "security_group_id" {
  default = "sg-09577d329cf16367a"
}