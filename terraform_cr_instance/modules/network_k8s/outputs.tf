output "network_id" {
  value = yandex_vpc_network.k8s-network.id
}
output "subnet_id" {
  value = yandex_vpc_subnet.k8s-subnet.id
}
output "subnet_zone" {
  value = yandex_vpc_subnet.k8s-subnet.zone
}