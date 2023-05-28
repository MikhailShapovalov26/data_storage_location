module "subnet" {
  source = "./modules/network"
}
module "vm" {
  source  = "./modules/instances"
  list_vm = local.public_instance_conf
}