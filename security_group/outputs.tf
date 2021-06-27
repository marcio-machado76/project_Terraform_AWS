output "sg-web" {
  description = "Security group id"
  value       = aws_security_group.web.id
}