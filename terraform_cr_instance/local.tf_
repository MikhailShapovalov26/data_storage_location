locals {
  ubuntu    = "fd8autg36kchufhej85b"
  natubuntu = "fd8v7ru46kt3s4o5f0uo"

  public_instance_conf = [
    {
      platform_id = "standard-v1"
      name        = "vm-1"
      hostname    = "vm-1"
      zone        = "ru-central1-a"
      memory      = 6
      image_id    = local.natubuntu
      size        = 30
      cores       = 4
      nat         = true
      ip_address  = "192.168.8.10"
      subnet_id   = module.subnet.subnet_nat
      user        = "user_ub.yml"

    },
    {
      platform_id = "standard-v1"
      name        = "vm-2"
      hostname    = "vm-2"
      zone        = "ru-central1-a"
      memory      = 6
      image_id    = local.ubuntu
      size        = 30
      cores       = 4
      nat         = false
      ip_address  = "192.168.10.10"
      subnet_id   = module.subnet.subnet_ip
      user        = "user_ub.yml"

    },
    {
      platform_id = "standard-v1"
      name        = "vm-3"
      hostname    = "vm-3"
      zone        = "ru-central1-a"
      memory      = 6
      image_id    = local.ubuntu
      size        = 30
      cores       = 4
      nat         = false
      ip_address  = "192.168.10.11"
      subnet_id   = module.subnet.subnet_ip
      user        = "user_ub.yml"
    }
  ]
}