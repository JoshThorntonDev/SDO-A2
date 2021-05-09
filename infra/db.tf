resource "aws_db_subnet_group" "main" {
  subnet_ids = [aws_subnet.data_az1.id, aws_subnet.data_az2.id, aws_subnet.data_az3.id]
}

resource "aws_security_group" "db" {
  description = "Allow MongoDB traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "postgres from vpc"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "Allow MongoDB"
  }

}

resource "aws_docdb_cluster" "a2-docdb" {
  cluster_identifier     = "docdb-cluster"
  availability_zones     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  master_username        = "admin"
  master_password        = "SDOAssignment2"
  vpc_security_group_ids = [aws_security_group.db.id]
}