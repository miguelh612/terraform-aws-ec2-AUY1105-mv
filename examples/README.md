# Ejemplo de uso

## Objetivo

Este módulo despliega una instancia EC2 con Apache instalada automáticamente y un grupo de seguridad que permite SSH desde Internet y HTTP desde el Application Load Balancer.

## Uso

Úsalo dentro de una VPC ya creada. Necesita la VPC, una subred pública, otra subred pública y el ID del grupo de seguridad del ALB para permitir el tráfico web entrante.

```hcl
module "ec2" {
	source                = "github.com/miguelh612/terraform-aws-ec2-AUY1105-mv?ref=v1.0.2"
	vpc_id                = module.vpc.vpc_id
	public_subnet_id      = module.vpc.public_subnet_id
	public_subnet_2_id    = module.vpc.public_subnet_2_id
	alb_security_group_id = module.alb.alb_security_group_id
}
```

El módulo expone la IP pública y el ID de la instancia en `ec2_public_ip` y `ec2_instance_id`.
