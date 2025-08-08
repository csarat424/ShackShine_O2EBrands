
output "security_group_id" {
  value = aws_security_group.Security_Group.id
}
output "vpc_id" {
  value = aws_vpc.ShackShine_VPC.id
}

output "public_subnet_id" {
  value = aws_subnet.Public_Subnet.id
}
