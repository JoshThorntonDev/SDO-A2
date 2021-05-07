
resource "aws_key_pair" "deployer" {
  key_name   = "rmit-assignment-2-key"
  public_key = file("~/keys/ec2-key.pub")
}

resource "aws_security_group" "allow_http_ssh" {
  description = "Allow SSH and http inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "ssh from internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1" 
  }

  tags = {
    Name = "allow_http_ssh"
  }
}