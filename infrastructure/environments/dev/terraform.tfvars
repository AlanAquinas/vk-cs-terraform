environment = "dev"
public_subnet_cidr = "10.0.1.0/24"
private_subnet_cidr = "10.0.2.0/24"

# Дополнительные настройки для dev
k8s_master_count = 1
k8s_node_count = 2
k8s_master_flavor = "Basic-1-2-20"
k8s_node_flavor = "Basic-1-2-20"