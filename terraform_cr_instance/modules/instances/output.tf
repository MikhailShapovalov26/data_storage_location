output "private_ip" {
  value = values(yandex_compute_instance.module_instanc)[*].network_interface.0.ip_address
}

output "external_ip" {
  value=values(yandex_compute_instance.module_instanc)[*].network_interface.0.nat_ip_address
}