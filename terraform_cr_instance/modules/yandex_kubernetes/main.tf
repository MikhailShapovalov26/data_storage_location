resource "yandex_kubernetes_cluster" "zonal_k8s_cluster" {
    name = "cluster"
    description = "my cluster in yandex cloud"
    network_id = var.network_id
    master {
      version = "1.24"
      zonal {
        zone = var.zone
        subnet_id = var.subnet_id
      }
      public_ip = true
    }
    service_account_id = var.service_account
    node_service_account_id =  var.service_account
    release_channel = "STABLE" 
}

resource "yandex_kubernetes_node_group" "k8s_node_group" {
    cluster_id = yandex_kubernetes_cluster.zonal_k8s_cluster.id
    name = "name"
    description = "k8s node group"
    version = "1.24"

    instance_template {
      platform_id = "standard-v3"
      network_interface {
        nat = true
        subnet_ids = [var.subnet_id]
      }
      resources {
        cores = 2
        memory = 4
        core_fraction = 50
      }
      scheduling_policy {
      preemptible = true
        }
        boot_disk {
        type = "network-hdd"
        size = 32
        }
        metadata = {
        ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
        }

    }
    scale_policy {
    fixed_scale {
      size = 1
    }
  }
  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "10:00"
      duration   = "4h30m"
    }
  }
}
