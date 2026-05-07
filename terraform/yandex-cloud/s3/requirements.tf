terraform {
    required_providers {
        yandex = {
            source = "yandex-cloud/yandex"
            version = ">= 0.90.0"
        }
    }
    required_version = ">= 0.13"
}

resource "yandex_iam_service_account" "s3er" {
    name = "s3er"
    description = "an s3 builder account"
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
    folder_id = local.folder_id
    role      = "editor"
    member    = "serviceAccount:${yandex_iam_service_account.s3er.id}"
}
