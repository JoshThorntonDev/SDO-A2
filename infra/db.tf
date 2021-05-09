resource "aws_db_subnet_group" "main" {
  subnet_ids = [aws_subnet.data_az1.id, aws_subnet.data_az2.id, aws_subnet.data_az3.id]
}