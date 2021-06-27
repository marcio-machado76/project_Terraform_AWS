resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc

  tags = {
    Name = "igw-terraform"
  }
}