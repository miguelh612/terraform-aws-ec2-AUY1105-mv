output "ec2_public_ip" {
    description = "Dirección IP pública de la instancia EC2"
  value = aws_instance.web.public_ip
}

output "ec2_instance_id" {
    description = "ID de la instancia EC2 creada"
  value = aws_instance.web.id
}
