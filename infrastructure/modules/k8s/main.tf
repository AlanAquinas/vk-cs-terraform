terraform {
  required_providers {
    vkcs = {
      source = "vk-cs/vkcs"
      version = "~> 0.8.0"  # Укажите нужную версию
    }
  }
  required_version = ">= 1.0.0"
}

data "vkcs_kubernetes_clustertemplate" "k8s-template" {
  version = "1.28"
}

data "vkcs_compute_flavor" "k8s_flavor_dev" {
  name = "Standard-2-6"  # Укажите имя нужного flavor'а
}

data "vkcs_compute_flavor" "k8s_flavor_prod" {
  name = "Standard-4-8"  # Укажите имя нужного flavor'а
}

resource "vkcs_compute_keypair" "k8s-keypair" {
  name = "${var.environment}-k8s-keypair"
}

resource "vkcs_kubernetes_cluster" "k8s_cluster" {
  name                = "${var.environment}-k8s-cluster"
  cluster_template_id = data.vkcs_kubernetes_clustertemplate.k8s-template.id
  master_count        = var.environment == "prod" ? 3 : 1 # Для prod используем 3 master-ноды
  master_flavor      = var.environment == "prod" ? data.vkcs_compute_flavor.k8s_flavor_prod.id : data.vkcs_compute_flavor.k8s_flavor_dev.id
  network_id         = var.network_id
  subnet_id          = var.public_subnet_id
  availability_zone  = "QAZ"

  labels = {
    environment = var.environment
    "cattle.io/creator" = "norman"
  }
  floating_ip_enabled = false
}

# Worker node group
resource "vkcs_kubernetes_node_group" "node_group" {
  name = "${var.environment}-node-group"
  cluster_id = vkcs_kubernetes_cluster.k8s_cluster.id
  flavor_id = var.environment == "prod" ? "Standard-4-8" : "Basic-1-2-20"
  node_count = var.environment == "prod" ? 3 : 2

  labels {
    key   = "environment"
    value = var.environment
  }

  labels {
    key   = "node-role"
    value = "node-worker"
  }
}

# Установка основных аддонов
resource "vkcs_kubernetes_addon" "monitoring" {
  cluster_id = vkcs_kubernetes_cluster.k8s_cluster.id
  addon_id = "kube-prometheus-stack"
  depends_on = [vkcs_kubernetes_cluster.k8s_cluster]
  namespace  = ""
}

resource "vkcs_kubernetes_addon" "ingress" {
  cluster_id = vkcs_kubernetes_cluster.k8s_cluster.id
  addon_id = "ingress-nginx"
  depends_on = [vkcs_kubernetes_cluster.k8s_cluster]
  namespace  = "ingress-nginx"
}