resource "yandex_vpc_network" "name" {
  name = "name"
}

resource "yandex_vpc_route_table" "route-network" {
  name = "routenetwork"
  network_id = yandex_vpc_network.name.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address = "192.168.8.10"
  }
}

resource "yandex_vpc_subnet" "nat" {
  name = "notsubnat"
  zone = "ru-central1-a"
  network_id = yandex_vpc_network.name.id
  v4_cidr_blocks = [ "192.168.8.0/24" ]
}
resource "yandex_vpc_subnet" "not_nat" {
  name           = "subnat"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.name.id
  route_table_id = yandex_vpc_route_table.route-network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}
