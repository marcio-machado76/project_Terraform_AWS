variable "sg-web" {
  type        = string
  description = "Security group id"
}

variable "public_subnet" {
  type        = list(string)
  description = "Subnet public id"
}

variable "ec2_id" {
  type        = list(string)
  description = "Id das instancias ec2"
}

variable "tag_elb" {
  type        = string
  description = "Nome do recurso elb"
}