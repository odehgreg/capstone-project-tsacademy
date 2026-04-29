output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id,
    aws_subnet.public_c.id
  ]
}

output "private_subnets" {
  value = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id,
    aws_subnet.private_c.id
  ]
}

output "nat_gateway_ips" {
  value = {
    nat_a = aws_eip.nat_a.public_ip
    nat_b = aws_eip.nat_b.public_ip
    nat_c = aws_eip.nat_c.public_ip
  }
}