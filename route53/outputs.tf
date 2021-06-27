output "namesrv" {
  description = "List nameservers"
  value       = [aws_route53_zone.wordpress.name_servers]
}
