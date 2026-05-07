provider "yandex" {
    zone = "ru-central1-a"
    cloud_id = local.cloud_id
    folder_id = local.folder_id
    service_account_key_file = "authorized_key.json"
}

provider "kubernetes" {
    host                   = local.k8s_host
    cluster_ca_certificate = local.k8s_cluster_ca_certificate
    config_path = "~/.kube/config"
}
