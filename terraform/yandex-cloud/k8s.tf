resource "yandex_kubernetes_cluster" "allergano" {
    name = "mlops"
    network_id = yandex_vpc_network.k8s_network.id
    master {
        public_ip = true
        master_location {
            zone      = yandex_vpc_subnet.k8s_subnet_a.zone
            subnet_id = yandex_vpc_subnet.k8s_subnet_a.id
        }
    }

    service_account_id      = yandex_iam_service_account.builder.id
    node_service_account_id = yandex_iam_service_account.builder.id

    network_policy_provider = "CALICO"

    depends_on = [
        yandex_resourcemanager_folder_iam_member.editor,
        yandex_resourcemanager_folder_iam_member.images-puller
    ]
}

resource "kubernetes_namespace" "argocd" {
    metadata {
        name = "argocd"
    }
    
    depends_on = [ 
        yandex_kubernetes_cluster.allergano
     ]
}

resource "yandex_kubernetes_node_group" "main" {
    cluster_id  = yandex_kubernetes_cluster.allergano.id
    name        = "main-node"
    version     = "1.26"

    instance_template {
        platform_id = "standard-v2"

        network_interface {
            nat                = true
            subnet_ids         = [yandex_vpc_subnet.k8s_subnet_a.id]
        }

        resources {
            memory = 4
            cores  = 4
        }

        boot_disk {
            type = "network-hdd"
            size = 64
        }

        scheduling_policy {
            preemptible = false
        }

        container_runtime {
            type = "containerd"
        }
    }

    scale_policy {
        fixed_scale {
            size = 1
        }
    }

    allocation_policy {
        location {
            zone = "ru-central1-a"
        }
    }

    maintenance_policy {
        auto_upgrade = true
        auto_repair  = true
    }
}

resource "helm_release" "argocd" {
    name = "argocd"
    repository       = "https://argoproj.github.io/argo-helm"
    version          = "6.8.1"
    chart            = "argo-cd"
    namespace        = kubernetes_namespace.argocd.id
    timeout          = "150"

    provisioner "local-exec" {
        command = <<EOT
            yc managed-kubernetes cluster get-credentials allergano --external --force
            kubectl patch svc argocd-server -n ${kubernetes_namespace.argocd.id} -p '{"spec": {"type": "LoadBalancer"}}'
        EOT
    }

    depends_on = [
        yandex_kubernetes_node_group.main
    ]
}
