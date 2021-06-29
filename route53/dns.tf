#################################################
## Criando Zona hospedada e adiconando registros
#################################################

resource "aws_route53_zone" "wordpress" {
  name = var.dns
}


resource "aws_route53_record" "sitewp" {
  zone_id = aws_route53_zone.wordpress.zone_id
  name    = "${var.meu_site}.${var.dns}"
  type    = "CNAME"
  ttl     = "300"
  records = [var.elb_endpoint]

}


resource "aws_route53_record" "banco" {
  zone_id = aws_route53_zone.wordpress.zone_id
  name    = "${var.db_name}.${var.dns}"
  type    = "CNAME"
  ttl     = "300"
  records = [var.dbrds]

}
