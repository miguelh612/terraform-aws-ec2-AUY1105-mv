# ─── SECURITY GROUP — EC2 ──────────────────────────────────────────────────────
# HTTP solo desde el ALB; SSH desde Internet (ajustar según necesidad)

resource "aws_security_group" "web" {
  name        = var.ec2_security_group_name
  description = "Permite trafico HTTP desde el ALB y SSH"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.public_cidr_block]
  }

  ingress {
    description     = "HTTP desde el ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.public_cidr_block]
  }

  tags = {
    Name = "sg-web"
  }
}

# ─── EC2 INSTANCE ──────────────────────────────────────────────────────────────

resource "aws_instance" "web" {
  ami                    = var.ec2_ami_id
  instance_type          = var.ec2_instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Servidor Web - Prueba 2</h1>" > /var/www/html/index.html
  EOF

  tags = {
    Name        = "ec2-web"
    Environment = "dev"
  }
}