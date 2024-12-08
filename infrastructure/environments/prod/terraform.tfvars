environment = "prod"
public_subnet_cidr = "10.1.1.0/24"
private_subnet_cidr = "10.1.2.0/24"

# Дополнительные настройки для prod
k8s_master_count = 3
k8s_node_count = 3
k8s_master_flavor = "Standard-4-8"
k8s_node_flavor = "Standard-4-8"