resource "aws_db_subnet_group" "rds" {
  name       = "subnet_group_rds"
  subnet_ids = var.private_subnet
  
  tags = {
    Name = "subnet group RDS"
  }
}
resource "aws_db_instance" "db_wordpress" {
  depends_on             = [aws_db_subnet_group.rds]
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = var.type_db
  identifier             = "dbterraformwp"
  db_subnet_group_name   = "subnet_group_rds"
  vpc_security_group_ids = [var.sg-web]
  name                   = "terraformrdswp"
  username               = var.dbadmin
  password               = var.db_passwd
  port                   = 3306
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true

}
