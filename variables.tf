# ─── SECURITY GROUP — ALB ──────────────────────────────────────────────────────
resource "aws_security_group" "alb" {
  name        = "test01-sg-alb"
  description = "Permite trafico HTTP entrante al ALB desde Internet"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP desde Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-alb"
  }
}

# ─── SECURITY GROUP — EC2 ──────────────────────────────────────────────────────
# HTTP solo desde el ALB; SSH desde Internet (ajustar según necesidad)
resource "aws_security_group" "web" {
  name        = "test01-sg-web"
  description = "Permite trafico HTTP desde el ALB y SSH"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description     = "HTTP desde el ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-web"
  }
}

# ─── EC2 INSTANCE ──────────────────────────────────────────────────────────────
resource "aws_instance" "web" {
  ami                    = "ami-0c02fb55956c7d316" # Amazon Linux 2 (us-east-1)
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
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

# ─── APPLICATION LOAD BALANCER ────────────────────────────────────────────────
resource "aws_lb" "main" {
  name               = "alb-prueba2"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.public.id, aws_subnet.public_2.id]

  enable_deletion_protection = false

  tags = {
    Name        = "alb-prueba2"
    Environment = "dev"
  }
}

# ─── TARGET GROUP ─────────────────────────────────────────────────────────────
resource "aws_lb_target_group" "web" {
  name     = "tg-web-prueba2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "tg-web-prueba2"
  }
}

# ─── REGISTRO DE LA EC2 EN EL TARGET GROUP ────────────────────────────────────
resource "aws_lb_target_group_attachment" "web" {
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.web.id
  port             = 80
}

# ─── LISTENER HTTP ────────────────────────────────────────────────────────────
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}