terraform {
  required_providers {
    vkcs = {
      source = "vk-cs/vkcs"
      version = "~> 0.8.0"  # Укажите нужную версию
    }
  }
  required_version = ">= 1.0.0"
}

# Внешняя сеть
data "vkcs_networking_network" "extnet" {
  name = "internet"
}

# Создание сети
resource "vkcs_networking_network" "network" {
  name           = "${var.environment}-network"
  admin_state_up = true
}

# Создание публичной подсети
resource "vkcs_networking_subnet" "public_subnet" {
  name            = "${var.environment}-public-subnet"
  network_id      = vkcs_networking_network.network.id
  cidr            = var.public_subnet_cidr
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
}

# Создание приватной подсети
resource "vkcs_networking_subnet" "private_subnet" {
  name            = "${var.environment}-private-subnet"
  network_id      = vkcs_networking_network.network.id
  cidr            = var.private_subnet_cidr
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
}

# Создание маршрутизатора
resource "vkcs_networking_router" "router" {
  name                = "${var.environment}-router"
  admin_state_up      = true
  external_network_id = data.vkcs_networking_network.extnet.id
}

# Подключение публичной подсети к маршрутизатору
resource "vkcs_networking_router_interface" "public" {
  router_id = vkcs_networking_router.router.id
  subnet_id = vkcs_networking_subnet.public_subnet.id
}

# Подключение приватной подсети к маршрутизатору
resource "vkcs_networking_router_interface" "private" {
  router_id = vkcs_networking_router.router.id
  subnet_id = vkcs_networking_subnet.private_subnet.id
}