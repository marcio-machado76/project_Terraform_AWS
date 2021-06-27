output "dbrds" {
  description = "Id do banco de dados RDS MySql"
  value       = aws_db_instance.db_wordpress.address
}