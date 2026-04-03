ui = false

storage "file" {
  path = "/var/openbao"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}

seal "static" {
  key_file = "/etc/openbao/unseal.key"
}

api_addr = "http://0.0.0.0:8200"
cluster_addr = "http://0.0.0.0:8201"
