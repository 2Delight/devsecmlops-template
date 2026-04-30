provider "yandex" {
    zone = "ru-central1-a"
    cloud_id = local.cloud_id
    folder_id = local.folder_id
    service_account_key_file = "authorized_key.json"
}
