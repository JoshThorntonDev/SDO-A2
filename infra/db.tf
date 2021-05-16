resource "aws_db_subnet_group" "main" {
  subnet_ids = [aws_subnet.data_az1.id, aws_subnet.data_az2.id, aws_subnet.data_az3.id]
}

resource "aws_security_group" "db" {
  description = "Allow MongoDB traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Access db from vpc"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  tags = {
    Name = "Allow MongoDB"
  }
}

resource "aws_docdb_cluster_instance" "a2-docdb-instances" {
  count              = var.db_instance_count
  identifier         = "docdb-cluster-instance-${count.index}"
  cluster_identifier = aws_docdb_cluster.a2-docdb.id
  instance_class     = var.db_instance_size
}

resource "aws_docdb_cluster" "a2-docdb" {
  cluster_identifier              = "docdb-cluster"
  availability_zones              = ["us-east-1a", "us-east-1b", "us-east-1c"]
  master_username                 = "dbuser"
  master_password                 = "SDOAssignment2"
  engine_version                  = "3.6"
  vpc_security_group_ids          = [aws_security_group.db.id]
  db_subnet_group_name            = aws_db_subnet_group.main.name
  skip_final_snapshot             = true
  db_cluster_parameter_group_name = "tls-disable"
}