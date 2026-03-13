resource "aws_security_group" "web_sg" {
  name = "terraform-web-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "web_server" {
  ami           = "ami-0b72821e2f351e396"
  instance_type = var.instance_type
  key_name      = "cicdkey"

  security_groups = [aws_security_group.web_sg.name]
  
# This script installs Apache and creates a simple landing page

              user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Hello from Terraform DevOps Project" > /var/www/html/index.html
              EOF


  tags = {
    Name = "DevOps-Portfolio-Instance"
  }
}
