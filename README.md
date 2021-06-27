## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_db"></a> [db](#module\_db) | ./rds | n/a |
| <a name="module_dns"></a> [dns](#module\_dns) | ./route53 | n/a |
| <a name="module_ec2-instance"></a> [ec2-instance](#module\_ec2-instance) | ./ec2 | n/a |
| <a name="module_elb"></a> [elb](#module\_elb) | ./elb | n/a |
| <a name="module_security-group"></a> [security-group](#module\_security-group) | ./security_group | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./vpc | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_az_count"></a> [az\_count](#input\_az\_count) | Numero de Zonas de disponibilidade | `number` | `4` | no |
| <a name="input_azs"></a> [azs](#input\_azs) | Zonas de disponibilidade | `list(string)` | <pre>[<br>  "us-east-1a",<br>  "us-east-1b",<br>  "us-east-1c",<br>  "us-east-1d"<br>]</pre> | no |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | CIDR da VPC | `string` | `"10.40.0.0/16"` | no |
| <a name="input_db_passwd"></a> [db\_passwd](#input\_db\_passwd) | password db | `string` | `"terraformrds+wordpress"` | no |
| <a name="input_dbadmin"></a> [dbadmin](#input\_dbadmin) | admin user db | `string` | `"admin"` | no |
| <a name="input_dns"></a> [dns](#input\_dns) | Nome do domínio que sera adicionado a zona hospedada no route53 | `string` | `"cloud-naveia.ml"` | no |
| <a name="input_ec2_count"></a> [ec2\_count](#input\_ec2\_count) | Quantidade de instancias Ec2 | `number` | `4` | no |
| <a name="input_key_pair"></a> [key\_pair](#input\_key\_pair) | Chave na AWS para se conectar via ssh | `string` | `"curso-devops"` | no |
| <a name="input_meu_site"></a> [meu\_site](#input\_meu\_site) | Nome do site sem o domínio | `string` | `"meu-site-wordpress"` | no |
| <a name="input_nacl"></a> [nacl](#input\_nacl) | Regras de Network Acls AWS | `map(object({ protocol = string, action = string, cidr_blocks = string, from_port = number, to_port = number }))` | <pre>{<br>  "100": {<br>    "action": "allow",<br>    "cidr_blocks": "0.0.0.0/0",<br>    "from_port": 22,<br>    "protocol": "tcp",<br>    "to_port": 22<br>  },<br>  "105": {<br>    "action": "allow",<br>    "cidr_blocks": "0.0.0.0/0",<br>    "from_port": 80,<br>    "protocol": "tcp",<br>    "to_port": 80<br>  },<br>  "110": {<br>    "action": "allow",<br>    "cidr_blocks": "0.0.0.0/0",<br>    "from_port": 443,<br>    "protocol": "tcp",<br>    "to_port": 443<br>  },<br>  "150": {<br>    "action": "allow",<br>    "cidr_blocks": "0.0.0.0/0",<br>    "from_port": 1024,<br>    "protocol": "tcp",<br>    "to_port": 65535<br>  }<br>}</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | Região na AWS | `string` | `"us-east-1"` | no |
| <a name="input_script"></a> [script](#input\_script) | caminho do script de instalação | `string` | `"script.sh"` | no |
| <a name="input_sg-cidr"></a> [sg-cidr](#input\_sg-cidr) | Portas de entrada do security group tcp e/ou udp | `map(object({ to_port = number, description = string, protocol = string, cidr_blocks = list(string) }))` | <pre>{<br>  "22": {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "Entrada ssh",<br>    "protocol": "tcp",<br>    "to_port": 22<br>  },<br>  "443": {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "Entrada https",<br>    "protocol": "tcp",<br>    "to_port": 443<br>  },<br>  "80": {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "Entrada http",<br>    "protocol": "tcp",<br>    "to_port": 80<br>  }<br>}</pre> | no |
| <a name="input_sg-self"></a> [sg-self](#input\_sg-self) | Portas de entrada do security group liberadas para o mesmo security group | `map(object({ to_port = number, description = string, protocol = string, self = bool }))` | <pre>{<br>  "3306": {<br>    "description": "Porta RDS MySql",<br>    "protocol": "tcp",<br>    "self": true,<br>    "to_port": 3306<br>  }<br>}</pre> | no |
| <a name="input_tag-sg"></a> [tag-sg](#input\_tag-sg) | Tag Name do security group | `string` | `"Sg-Wordpress_Terraform"` | no |
| <a name="input_tag_elb"></a> [tag\_elb](#input\_tag\_elb) | Nome do recurso elb | `string` | `"Terraform-elb"` | no |
| <a name="input_tag_vpc"></a> [tag\_vpc](#input\_tag\_vpc) | Tag Name da VPC | `string` | `"VPC Terraform"` | no |
| <a name="input_type"></a> [type](#input\_type) | Type instance | `string` | `"t3.medium"` | no |
| <a name="input_type_db"></a> [type\_db](#input\_type\_db) | Type instance | `string` | `"db.t2.micro"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dbrds"></a> [dbrds](#output\_dbrds) | Id do banco de dados RDS MySql |
| <a name="output_ec2-public_ip"></a> [ec2-public\_ip](#output\_ec2-public\_ip) | Public IP Ec2 |
| <a name="output_ec2_id"></a> [ec2\_id](#output\_ec2\_id) | Id das instancias ec2 |
| <a name="output_elb_endpoint"></a> [elb\_endpoint](#output\_elb\_endpoint) | dns name do load balance |
| <a name="output_namesrv"></a> [namesrv](#output\_namesrv) | List nameservers |
