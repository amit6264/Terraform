output "public_ip" {
    value = aws_instance.name.public_ip
}

output "PrivatIP" {
    value = aws_instance.name.private_ip
}