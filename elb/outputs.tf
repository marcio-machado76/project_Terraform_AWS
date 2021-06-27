output "elb_endpoint" {
  value       = aws_elb.elb_terraform.dns_name
  description = "dns name do load balance"
}
