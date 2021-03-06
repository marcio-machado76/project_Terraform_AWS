variable "dns" {
  type        = string
  description = "Nome do domínio a ser registrado no route53"
}


variable "meu_site" {
  type        = string
  description = "Nome do site sem o domínio"
}

variable "db_name" {
  type        = string
  description = "Nome para o banco de dados no route53"
}

variable "elb_endpoint" {
  type        = string
  description = "dns name do load balance"
}


variable "dbrds" {
  type        = string
  description = "ID do Banco de dados"
}
