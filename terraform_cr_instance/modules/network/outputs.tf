output "subnet_ip" {
  description = "subnet ip"
  value       = yandex_vpc_subnet.not_nat.id
}

output "subnet_nat" {
  description = "subnet ip"
  value       = yandex_vpc_subnet.nat.id
}
