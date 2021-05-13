output "public_dns" {
  value = aws_lb.a2-lb.dns_name
}

output "public_ip" {
  value = aws_instance.web.public_ip
}

output "db_dns_name" {
  value = aws_docdb_cluster.a2-docdb.endpoint
  sensitive = true
}

output "db_pw" {
  value     = aws_docdb_cluster.a2-docdb.master_password
  sensitive = true
}

output "db_username" {
  value     = aws_docdb_cluster.a2-docdb.master_username
  sensitive = true
}