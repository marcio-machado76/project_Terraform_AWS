variable "vpc" {
  type        = string
  description = "Id da VPC"
}

variable "sg-cidr" {
  description = "Portas de entrada do security group tcp e/ou udp"
  type        = map(any)
}

variable "sg-self" {
  description = "Portas de entrada do security group liberadas para o mesmo security group"
  type        = map(any)
}

variable "tag-sg" {
  description = "Tag Name do security group"
  type        = string
}
