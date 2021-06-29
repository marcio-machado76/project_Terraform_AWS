# Desafio 2
    * Informações fornecidas:

    O site é em Wordpress com banco de dados MySQL;
    Atualmente ele está rodando em uma maquina com 2 vCPU e 2GB RAM;
    Atualmente a empresa ainda não possui um certificado HTTPS;
    O domínio da empresa está atualmente hospedado em um servidor local.

    * As exigências  são:

    A infraestrutura deve ser desenvolvida como código com Terraform;
    A infraestrutura deve ser de fácil portabilidade;
    A infraestrutura deve ser criada na nuvem da AWS.
## 

**Para consumir estes módulos, serão necessários alguns arquivos e configurações, clique nos arquivos abaixo e saiba mais:**
<details>
   <summary>versions.tf - Arquivo com as versões dos providers.</summary>


    terraform {
    required_version = "~> 0.14"

    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 3.0"
        }
    }
    }
</details> 

<details>
<summary>main.tf - Arquivo que irá consumir os módulos deverá seguir a seguinte estrutura.</summary>
    

    provider "aws" {
    region  = var.region

    }


    module "vpc" {
    source        = "github.com/marcio-machado76/project_Terraform_AWS.git/vpc"
    cidr          = var.cidr
    azs           = var.azs
    region        = var.region
    vpc           = module.vpc.vpc
    tag_vpc       = var.tag_vpc
    az_count      = var.az_count
    nacl          = var.nacl
    vpc_cidrblock = module.vpc.vpc_cidrblock

    }


    module "security-group" {
    source  = "github.com/marcio-machado76/project_Terraform_AWS.git/security_group"
    vpc     = module.vpc.vpc
    sg-self = var.sg-self
    sg-cidr = var.sg-cidr
    tag-sg  = var.tag-sg

    }


    module "ec2-instance" {
    source        = "github.com/marcio-machado76/project_Terraform_AWS.git/ec2"
    sg-web        = module.security-group.sg-web
    public_subnet = module.vpc.public_subnet
    script        = var.script
    key_pair      = var.key_pair
    type          = var.type
    ec2_count     = var.ec2_count

    }


    module "db" {
    source = "github.com/marcio-machado76/project_Terraform_AWS.git/rds"
    #public_subnet = module.vpc.public_subnet
    private_subnet = module.vpc.private_subnet
    sg-web         = module.security-group.sg-web
    type_db        = var.type_db
    dbadmin        = var.dbadmin
    db_passwd      = var.db_passwd

    }


    module "elb" {
    source        = "github.com/marcio-machado76/project_Terraform_AWS.git/elb"
    public_subnet = module.vpc.public_subnet
    sg-web        = module.security-group.sg-web
    ec2_id        = module.ec2-instance.ec2_id
    tag_elb       = var.tag_elb

    }


    module "dns" {
    source       = "github.com/marcio-machado76/project_Terraform_AWS.git/route53"
    elb_endpoint = module.elb.elb_endpoint
    dbrds        = module.db.dbrds
    dns          = var.dns
    meu_site     = var.meu_site
    db_name      = var.db_name

    }

 </details>
 
 <details>
<summary>variables.tf - Contém variáveis de todos os módulos e pode ter os valores alterados de acordo com a necessidade.</summary>


    variable "region" {
    type        = string
    description = "Região na AWS"
    default     = "us-east-1"
    }


    variable "azs" {
    description = "Zonas de disponibilidade"
    type        = list(string)
    default     = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
    }

    variable "cidr" {
    description = "CIDR da VPC"
    type        = string
    default     = "10.40.0.0/16"
    }

    variable "tag_vpc" {
    description = "Tag Name da VPC"
    type        = string
    default     = "VPC Terraform"
    }

    variable "az_count" {
    type        = number
    description = "Numero de Zonas de disponibilidade"
    default     = 2
    }


    variable "nacl" {
    description = "Regras de Network Acls AWS"
    type        = map(object({ protocol = string, action = string, cidr_blocks = string, from_port = number, to_port = number }))
    default = {
        100 = { protocol = "tcp", action = "allow", cidr_blocks = "0.0.0.0/0", from_port = 22, to_port = 22 }
        105 = { protocol = "tcp", action = "allow", cidr_blocks = "0.0.0.0/0", from_port = 80, to_port = 80 }
        110 = { protocol = "tcp", action = "allow", cidr_blocks = "0.0.0.0/0", from_port = 443, to_port = 443 }
        150 = { protocol = "tcp", action = "allow", cidr_blocks = "0.0.0.0/0", from_port = 1024, to_port = 65535 }
    }
    }


    variable "sg-cidr" {
    description = "Portas de entrada do security group tcp e/ou udp"

    type = map(object({ to_port = number, description = string, protocol = string, cidr_blocks = list(string) }))
    default = {
        22  = { to_port = 22, description = "Entrada ssh", protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
        80  = { to_port = 80, description = "Entrada http", protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
        443 = { to_port = 443, description = "Entrada https", protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
    }
    }

    variable "sg-self" {
    description = "Portas de entrada do security group liberadas para o mesmo security group"

    type = map(object({ to_port = number, description = string, protocol = string, self = bool }))
    default = {
        3306 = { to_port = 3306, description = "Porta RDS MySql", protocol = "tcp", self = true }

    }
    }

    variable "tag-sg" {
    description = "Tag Name do security group"
    type        = string
    default     = "Sg-Wordpress_Terraform"
    }


    variable "key_pair" {
    type        = string
    description = "Chave na AWS para se conectar via ssh"
    default     = "curso-devops"
    }

    variable "type" {
    type        = string
    default     = "t2.micro"
    description = "Type instance"
    }

    
    variable "type_db" {
    type        = string
    default     = "db.t2.micro"
    description = "Type instance"
    }


    variable "dbadmin" {
    description = "admin user db"
    sensitive   = true
    default     = "admin"
    }


    variable "db_passwd" {
    description = "password db"
    sensitive   = true
    default     = "terraformrds+wordpress"
    }


    variable "script" {
    type        = string
    description = "caminho do script de instalação"
    default     = "script.sh"
    }


    variable "ec2_count" {
    type        = number
    description = "Quantidade de instancias Ec2"
    default     = 2
    }


    variable "tag_elb" {
    type        = string
    description = "Nome do recurso elb"
    default     = "Terraform-elb"
    }

        
    variable "dns" {
    type        = string
    description = "Nome do domínio que sera adicionado a zona hospedada no route53"
    default     = "meu-dominio"
    }


    variable "meu_site" {
    type        = string
    description = "Nome do site sem o domínio"
    default     = "meu-site-wordpress"
    }


    variable "db_name" {
    type        = string
    description = "Nome para o banco de dados no route53"
    default     = "banco"
    }
</details>

<details>   
   
<summary>outputs.tf - Outputs de recursos que serão utilizados em outros módulos.</summary>

    output "ec2-public_ip" {
    description = "Public IP Ec2"
    value       = module.ec2-instance.ec2-public_ip
    }


    output "dbrds" {
    description = "Id do banco de dados RDS MySql"
    value       = module.db.dbrds
    sensitive   = true
    }


    output "namesrv" {
    description = "List nameservers"
    value       = module.dns.namesrv
    }

    output "ec2_id" {
    description = "Id das instancias ec2"
    value       = module.ec2-instance.ec2_id
    }

    output "elb_endpoint" {
    value       = module.elb.elb_endpoint
    description = "dns name do load balance"
    }

</details>

<details>
<summary>script.sh - Script a ser executado no campo "user data" da instancia Ec2.</summary>


    #!/bin/bash

    # Update system
    apt update
    apt upgrade -y

    hostnamectl set-hostname wordpress
    sleep 2
    # install Docker
    apt  install docker.io -y
    usermod -aG docker ubuntu 
    clear
    curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    mkdir -p /home/ubuntu/site
    touch /home/ubuntu/docker-compose.yaml

    cat <<EOF > /home/ubuntu/docker-compose.yaml
    wordpress:
        image: wordpress:latest
        restart: always
        ports:
        - "80:80"
        environment:
        WORDPRESS_DB_HOST: <nome-do-banco>.<seu-domínio>:3306
        WORDPRESS_DB_USER: <user para o banco RDS>
        WORDPRESS_DB_PASSWORD: <password do banco RDS>
        WORDPRESS_DB_NAME: terraformrdswp
        volumes:
        ["site/:/var/www/html"]

    EOF
    clear
    cd /home/ubuntu/ && docker-compose up

</details>

## Providers

* AWS

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |



## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_db"></a> [db](#module\_db) | github.com/marcio-machado76/project_Terraform_AWS.git/rds | n/a |
| <a name="module_dns"></a> [dns](#module\_dns) | github.com/marcio-machado76/project_Terraform_AWS.git/route53 | n/a |
| <a name="module_ec2-instance"></a> [ec2-instance](#module\_ec2-instance) | github.com/marcio-machado76/project_Terraform_AWS.git/ec2 | n/a |
| <a name="module_elb"></a> [elb](#module\_elb) | github.com/marcio-machado76/project_Terraform_AWS.git/elb | n/a |
| <a name="module_security-group"></a> [security-group](#module\_security-group) | github.com/marcio-machado76/project_Terraform_AWS.git/security_group | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | github.com/marcio-machado76/project_Terraform_AWS.git/vpc | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_az_count"></a> [az\_count](#input\_az\_count) | Numero de Zonas de disponibilidade | `number` | `2` | no |
| <a name="input_azs"></a> [azs](#input\_azs) | Zonas de disponibilidade | `list(string)` | <pre>[<br>  "us-east-1a",<br>  "us-east-1b",<br>  "us-east-1c",<br>  "us-east-1d"<br>]</pre> | no |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | CIDR da VPC | `string` | `"10.40.0.0/16"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Nome para o banco de dados no route53 | `string` | `"meu-banco"` | no |
| <a name="input_db_passwd"></a> [db\_passwd](#input\_db\_passwd) | password db | `string` | `"senha-do-rds"` | no |
| <a name="input_dbadmin"></a> [dbadmin](#input\_dbadmin) | admin user db | `string` | `"user-admin-do-RDS"` | no |
| <a name="input_dns"></a> [dns](#input\_dns) | Nome do domínio que sera adicionado a zona hospedada no route53 | `string` | `"exemplo.com"` | no |
| <a name="input_ec2_count"></a> [ec2\_count](#input\_ec2\_count) | Quantidade de instancias Ec2 | `number` | `2` | no |
| <a name="input_key_pair"></a> [key\_pair](#input\_key\_pair) | Chave na AWS para se conectar via ssh | `string` | `"minha-key"` | no |
| <a name="input_meu_site"></a> [meu\_site](#input\_meu\_site) | Nome do site sem o domínio | `string` | `"meu-site-wordpress"` | no |
| <a name="input_nacl"></a> [nacl](#input\_nacl) | Regras de Network Acls AWS | `map(object({ protocol = string, action = string, cidr_blocks = string, from_port = number, to_port = number }))` | <pre>{<br>  "100": {<br>    "action": "allow",<br>    "cidr_blocks": "0.0.0.0/0",<br>    "from_port": 22,<br>    "protocol": "tcp",<br>    "to_port": 22<br>  },<br>  "105": {<br>    "action": "allow",<br>    "cidr_blocks": "0.0.0.0/0",<br>    "from_port": 80,<br>    "protocol": "tcp",<br>    "to_port": 80<br>  },<br>  "110": {<br>    "action": "allow",<br>    "cidr_blocks": "0.0.0.0/0",<br>    "from_port": 443,<br>    "protocol": "tcp",<br>    "to_port": 443<br>  },<br>  "150": {<br>    "action": "allow",<br>    "cidr_blocks": "0.0.0.0/0",<br>    "from_port": 1024,<br>    "protocol": "tcp",<br>    "to_port": 65535<br>  }<br>}</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | Região na AWS | `string` | `"us-east-1"` | no |
| <a name="input_script"></a> [script](#input\_script) | caminho do script de instalação | `string` | `"script.sh"` | no |
| <a name="input_sg-cidr"></a> [sg-cidr](#input\_sg-cidr) | Portas de entrada do security group tcp e/ou udp | `map(object({ to_port = number, description = string, protocol = string, cidr_blocks = list(string) }))` | <pre>{<br>  "22": {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "Entrada ssh",<br>    "protocol": "tcp",<br>    "to_port": 22<br>  },<br>  "443": {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "Entrada https",<br>    "protocol": "tcp",<br>    "to_port": 443<br>  },<br>  "80": {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "Entrada http",<br>    "protocol": "tcp",<br>    "to_port": 80<br>  }<br>}</pre> | no |
| <a name="input_sg-self"></a> [sg-self](#input\_sg-self) | Portas de entrada do security group liberadas para o mesmo security group | `map(object({ to_port = number, description = string, protocol = string, self = bool }))` | <pre>{<br>  "3306": {<br>    "description": "Porta RDS MySql",<br>    "protocol": "tcp",<br>    "self": true,<br>    "to_port": 3306<br>  }<br>}</pre> | no |
| <a name="input_tag-sg"></a> [tag-sg](#input\_tag-sg) | Tag Name do security group | `string` | `"Sg-Wordpress_Terraform"` | no |
| <a name="input_tag_elb"></a> [tag\_elb](#input\_tag\_elb) | Nome do recurso elb | `string` | `"Terraform-elb"` | no |
| <a name="input_tag_vpc"></a> [tag\_vpc](#input\_tag\_vpc) | Tag Name da VPC | `string` | `"VPC Terraform"` | no |
| <a name="input_type"></a> [type](#input\_type) | Type instance | `string` | `"t2.micro"` | no |
| <a name="input_type_db"></a> [type\_db](#input\_type\_db) | Type instance | `string` | `"db.t2.micro"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dbrds"></a> [dbrds](#output\_dbrds) | Id do banco de dados RDS MySql |
| <a name="output_ec2-public_ip"></a> [ec2-public\_ip](#output\_ec2-public\_ip) | Public IP Ec2 |
| <a name="output_ec2_id"></a> [ec2\_id](#output\_ec2\_id) | Id das instancias ec2 |
| <a name="output_elb_endpoint"></a> [elb\_endpoint](#output\_elb\_endpoint) | dns name do load balance |
| <a name="output_namesrv"></a> [namesrv](#output\_namesrv) | List nameservers |



## Como usar.
  - Para utilizar localmente crie os arquivos descritos no começo deste tutorial, main.tf, versions.tf, variables.tf, outputs.tf e script.sh.
  - Após criar os arquivos, atente-se aos valores default das variáveis, pois podem ser alterados de acordo com sua necessidade. 
  - As variáveis **az_count** e **ec2_count** devem conter valores iguais, para que a quantidade de instancias seja equivalente a quantidade de subnets publicas para que funcione corretamente o load balance.
  - É necessário editar alguns campos no arquivo **script.sh**, especificamente nas variáveis de ambiente **WORDPRESS_DB_HOST**, **WORDPRESS_DB_USER** e **WORDPRESS_DB_PASSWORD** para coincidir com os inputs utilizados na criação do RDS.
  - Também é necessário informar seu domínio na variável **dns**, o nome de host do seu site na variável **meu_site** e o nome do banco RDS na variável **db_name**.
  Certifique-se que possua as credenciais da AWS - **AWS_ACCESS_KEY_ID** e **AWS_SECRET_ACCESS_KEY**.
  - Para poder acessar as instancias crie uma "key pair" e adicione o nome de sua chave à variável **key_pair**.

### Comandos
Para consumir os módulos deste repositório é necessário ter o terraform instalado ou utilizar o container do terraform dentro da pasta do seu projeto da seguinte forma:

* `docker run -it -v $PWD:/app -w /app --entrypoint "" hashicorp/terraform:light sh` 
    
Em seguida exporte as credenciais da AWS:

* `export AWS_ACCESS_KEY_ID=sua_access_key_id`
* `export AWS_SECRET_ACCESS_KEY=sua_secret_access_key`
    
Agora é só executar os comandos do terraform:

* `terraform init` - Comando irá baixar todos os modulos e plugins necessários.
* `terraform fmt` - Para verificar e formatar a identação dos arquivos.
* `terraform validate` - Para verificar e validar se o código esta correto.
* `terraform plan` - Para criar um plano de todos os recursos que serão utilizados.
* `terraform apply` - Para aplicar a criação/alteração dos recursos. 
