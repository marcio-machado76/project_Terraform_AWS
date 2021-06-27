variable "key_pair" {
  type        = string
  description = "Chave para se conectar ssh"
}


variable "type" {
  type        = string
  description = "Type instance"
}


variable "script" {
  type        = string
  description = "caminho do script de instalação"
}

variable "sg-web" {
  type        = string
  description = "Security group id"
}

variable "public_subnet" {
  type        = list(string)
  description = "Subnet public id"
}

variable "ec2_count" {
  type        = number
  description = "Quantidade de instancias Ec2"
}