output "vpc-id" {
  value = aws_vpc.example.id
}
output "public_instance_ips" {
  value = aws_instance.public-instance.public_ip
}

output "private_instance_ips" {
  value = aws_instance.private-instance.private_ip
}