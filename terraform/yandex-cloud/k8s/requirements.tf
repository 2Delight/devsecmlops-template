terraform {
    required_providers {
        yandex = {
            source = "yandex-cloud/yandex"
            version = ">= 0.90.0"
        }
    }
    required_version = ">= 0.13"
}

resource "yandex_iam_service_account" "k8ser" {
    name = "k8ser"
    description = "a k8s builder account"
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
    folder_id = local.folder_id
    role      = "editor"
    member    = "serviceAccount:${yandex_iam_service_account.k8ser.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "images-puller" {
    folder_id = local.folder_id
    role      = "container-registry.images.puller"
    member    = "serviceAccount:${yandex_iam_service_account.k8ser.id}"
}
