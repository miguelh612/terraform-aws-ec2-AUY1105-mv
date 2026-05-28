output "ec2_public_ip" {
    description = "Dirección IP pública de la instancia EC2"
  value = aws_instance.web.public_ip
}

output "ec2_instance_id" {
    description = "ID de la instancia EC2 creada"
  value = aws_instance.web.id
}

output "alb_dns_name" {
  description = "DNS publico del Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_arn" {
  description = "ARN del Application Load Balancer"
  value       = aws_lb.main.arn
}
