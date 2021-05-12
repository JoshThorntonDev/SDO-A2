
resource "aws_key_pair" "deployer" {
  key_name   = "rmit-assignment-2-key"
  public_key = file("~/keys/ec2-key.pub")
}





resource "aws_security_group" "allow_http" {
  vpc_id      = aws_vpc.main.id
  description = "allow http"

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
    Name = "allow_http"
  }
}

resource "aws_security_group" "allow_ssh" {
  vpc_id      = aws_vpc.main.id
  description = "allow ssh"

  ingress {
    description = "ssh from internet"
    from_port   = 22
    to_port     = 22
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
    Name = "allow_ssh"
  }
}

resource "aws_security_group" "allow_5000" {
  vpc_id      = aws_vpc.main.id
  description = "Allow access on port 5000"

  ingress {
    description = "enable access on port 5000"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

}

resource "aws_instance" "web" {
  ami                         = "ami-0d5eff06f840b45e9"
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private_az1.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.allow_5000.id, aws_security_group.allow_ssh.id]

  tags = {
    Name = "Assignment 2 EC2"
  }
}

resource "aws_lb_target_group" "a2_lb_target_group" {
  name     = "a2-target-group"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb" "a2-lb" {
  name               = "a2-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_http.id]
  subnets            = [aws_subnet.public_az1.id, aws_subnet.public_az2.id, aws_subnet.public_az3.id]


}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.a2-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.a2_lb_target_group.arn
  }
}


resource "aws_lb_target_group_attachment" "tg-attachment" {
  target_group_arn = aws_lb_target_group.a2_lb_target_group.arn
  target_id        = aws_instance.web.id
  port             = 5000
}