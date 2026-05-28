variable "vpc_id" {
  description = "ID de la VPC creada"
  type = string
}

variable "public_subnet_id" {
  description = "ID de la subred pública"
  type = string
}

variable "public_subnet_2_id" {
  description = "ID de la subred pública 2"
  type = string
}

variable "ec2_ami_id" {
  description = "ID de la AMI para la instancia EC2"
  type = string
  default = "ami-0c02fb55956c7d316"
}

variable "ec2_instance_type" {
  description = "Tipo de instancia EC2"
  type = string
  default = "t2.micro"
}

variable "public_cidr_block" {
  description = "CIDR block para la subred pública"
  type = string
  default = "0.0.0.0/0"
}

variable "ec2_security_group_name" {
  description = "Nombre del grupo de seguridad para la instancia EC2"
  type = string
  default = "test01-sg-web"
}

variable "alb_security_group_id" {
  description = "ID del grupo de seguridad asociado al Application Load Balancer"
  type = string
}