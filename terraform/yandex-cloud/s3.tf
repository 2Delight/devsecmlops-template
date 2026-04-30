
resource "yandex_iam_service_account" "s3_sa" {
  name = "s3-bucket-sa"
}

resource "yandex_resourcemanager_folder_iam_member" "s3_admin" {
  folder_id = local.folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.s3_sa.id}"
}

resource "yandex_iam_service_account_static_access_key" "s3_key" {
  service_account_id = yandex_iam_service_account.s3_sa.id
  description        = "Static key for Object Storage"
}

resource "yandex_storage_bucket" "bucket" {
  bucket     = local.bucket_name
  access_key = yandex_iam_service_account_static_access_key.s3_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.s3_key.secret_key

  anonymous_access_flags {
    read        = false
    list        = false
    config_read = false
  }
}
