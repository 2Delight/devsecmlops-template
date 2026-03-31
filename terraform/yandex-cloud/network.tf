resource "yandex_vpc_network" "k8s_network" {
    name = "k8s-network"
}

resource "yandex_vpc_subnet" "k8s_subnet_a" {
    name = "k8s-subnet-a"
    v4_cidr_blocks = ["10.128.0.0/24"]
    zone           = "ru-central1-a"
    network_id     = yandex_vpc_network.k8s_network.id
}

resource "yandex_vpc_security_group" "k8s_traffic" {
    name        = "k8s-traffic"
    description = "Правила группы обеспечивают базовую работоспособность кластера Managed Service for Kubernetes. Примените ее к кластеру и группам узлов."
    network_id  = yandex_vpc_network.k8s_network.id
    ingress {
        protocol          = "TCP"
        description       = "Правило разрешает входящий трафик из интернета"
        v4_cidr_blocks    = ["0.0.0.0/0"]
        port = 443
    }
    ingress {
        protocol          = "TCP"
        description       = "Правило разрешает входящий трафик из интернета"
        v4_cidr_blocks    = ["0.0.0.0/0"]
        port = 8080
    }
}
