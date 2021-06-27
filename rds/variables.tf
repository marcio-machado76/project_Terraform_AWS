variable "private_subnet" {
  type        = list(string)
  description = "Subnet private id"

}
/*
variable "public_subnet" {
  type        = list(string)
  description = "Subnet private id"

}
*/
variable "type_db" {
  type        = string
  description = "Tipo de instancia do banco de dados"

}

variable "sg-web" {
  type        = string
  description = "ID do security group"
}

variable "dbadmin" {
  description = "admin user db"
  sensitive   = true
}

variable "db_passwd" {
  description = "password db"
  sensitive   = true
}