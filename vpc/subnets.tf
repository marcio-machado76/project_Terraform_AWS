# Subnets

data "aws_availability_zones" "aws_azs" {
}

resource "aws_subnet" "private" {
  count             = var.az_count
  cidr_block        = cidrsubnet(var.vpc_cidrblock, 8, (count.index + 1))
  availability_zone = data.aws_availability_zones.aws_azs.names[count.index]
  vpc_id            = var.vpc

  tags = {
    Name = "Private-${count.index + 1}"
  }
}

resource "aws_subnet" "public" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(var.vpc_cidrblock, 8, var.az_count + (count.index + 1))
  availability_zone       = data.aws_availability_zones.aws_azs.names[count.index]
  vpc_id                  = var.vpc
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-${count.index + 1}"
  }
}