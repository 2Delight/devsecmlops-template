locals {
    # Yandex Cloud variables.
    cloud_id = "b1ga6pgsesj5pfj1f7nd"
    folder_id = "b1gl1vl4sg7ivbia87i9"

    # Kubernetes variables.
    k8s_host = yandex_kubernetes_cluster.mlops.master[0].external_v4_endpoint
    k8s_cluster_ca_certificate = yandex_kubernetes_cluster.mlops.master[0].cluster_ca_certificate
}
