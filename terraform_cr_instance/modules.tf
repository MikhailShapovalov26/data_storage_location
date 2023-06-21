# module "subnet" {
#   source = "./modules/network"
# }
# module "vm" {
#   source  = "./modules/instances"
#   list_vm = local.public_instance_conf
# }
module "service_account" {
  source       = "./modules/service_account"
  yc_folder_id = local.folder_id
}
module "network_k8s" {
  source = "./modules/network_k8s"
  zone   = "ru-central1-a"
}
module "yandex_kubernetes" {
  source          = "./modules/yandex_kubernetes"
  network_id      = module.network_k8s.network_id
  subnet_id       = module.network_k8s.subnet_id
  zone            = module.network_k8s.subnet_zone
  service_account = module.service_account.service_account
  depends_on      = [module.service_account, module.network_k8s]
}