output "public_dns" {
  value = aws_lb.a2-lb.dns_name
}

output "public_ip" {
  value = aws_instance.web.public_ip
}