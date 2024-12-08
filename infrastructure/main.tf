module "network" {
  source = ".\\modules\\network"

  environment        = var.environment
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
}

module "security" {
  source = ".\\modules\\security"

  environment = var.environment
}

module "k8s" {
  source = ".\\modules\\k8s"

  environment = var.environment
  network_id = module.network.network_id
  public_subnet_id = module.network.public_subnet_id
}