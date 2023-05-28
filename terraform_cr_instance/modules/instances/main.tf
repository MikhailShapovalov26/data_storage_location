resource "yandex_compute_instance" "module_instanc" {
  for_each = { for key, value in var.list_vm : key => value }
  platform_id = each.value.platform_id
  name = each.value.name
  hostname = each.value.hostname
  zone= each.value.zone

  resources {
    memory = each.value.memory
    cores = each.value.cores
    core_fraction = 20
  }
  boot_disk {
    initialize_params {
      image_id = each.value.image_id
      size = each.value.size
    }
  }
  network_interface {
    subnet_id = each.value.subnet_id
    nat = each.value.nat
    ip_address = each.value.ip_address
  }
  metadata = {
    user-data = (
      file("./data/user-data/${each.value.user}")
    )
  }
  scheduling_policy {
    preemptible = true
  }
}