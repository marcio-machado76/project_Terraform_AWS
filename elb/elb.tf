

resource "aws_elb" "elb_terraform" {
  name = "elb-terraform"

  subnets         = var.public_subnet
  security_groups = [var.sg-web]
  internal        = false

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
    //ssl_certificate_id = ""
  }


  instances                   = var.ec2_id
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 300

  tags = {
    Name = var.tag_elb
  }
}

resource "aws_lb_cookie_stickiness_policy" "stickness" {
  name                     = "elb-policy"
  load_balancer            = aws_elb.elb_terraform.id
  lb_port                  = 80
  cookie_expiration_period = 420
}