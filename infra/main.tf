provider "aws" {
  version = "~> 2.23"
  region  = "us-east-1"
}

resource "aws_lb_target_group" "a2_lb_target_group" {
  name     = "a2-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}
