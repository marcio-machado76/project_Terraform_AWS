# Variaveis VPC
variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "cidr" {
  description = "CIDR da VPC"
  type        = string
}

variable "vpc" {
  type        = string
  description = "Id da VPC"

}

variable "vpc_cidrblock" {
  type        = string
  description = "Idendificador da VPC"
}

variable "region" {
  type        = string
  description = "Região na AWS"
}

variable "azs" {
  type        = list(string)
  description = "Zonas de disponibilidade"
}

variable "tag_vpc" {
  type        = string
  description = "Tag Name da VPC"
}

variable "az_count" {
  type        = number
  description = "Quantidade de zonas de disponibilidade"
}

variable "nacl" {
  description = "Regras de Network Acls AWS"
  type        = map(any)
}