terraform {
  required_providers {
    vkcs = {
      source = "vk-cs/vkcs"
      version = "~> 0.8.0"
    }
  }
  required_version = ">= 1.0.0"
}

# Группа безопасности для публичных сервисов
resource "vkcs_networking_secgroup" "public" {
  name        = "${var.environment}-public-sg"
  description = "Security group for public services"
}

# Группа безопасности для приватных сервисов
resource "vkcs_networking_secgroup" "private" {
  name        = "${var.environment}-private-sg"
  description = "Security group for private services"
}

# Правила для публичной группы безопасности
resource "vkcs_networking_secgroup_rule" "public_ingress_http" {
  direction         = "ingress"
  ethertype        = "IPv4"
  protocol         = "tcp"
  port_range_min   = 80
  port_range_max   = 80
  security_group_id = vkcs_networking_secgroup.public.id
}

resource "vkcs_networking_secgroup_rule" "public_ingress_https" {
  direction         = "ingress"
  ethertype        = "IPv4"
  protocol         = "tcp"
  port_range_min   = 443
  port_range_max   = 443
  security_group_id = vkcs_networking_secgroup.public.id
}

# Правила для приватной группы безопасности
resource "vkcs_networking_secgroup_rule" "private_ingress_internal" {
  direction         = "ingress"
  ethertype        = "IPv4"
  protocol         = "tcp"
  remote_group_id   = vkcs_networking_secgroup.public.id
  security_group_id = vkcs_networking_secgroup.private.id
}