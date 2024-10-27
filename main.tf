resource "google_storage_bucket" "funcao_bucket" {
  name     = "bucket-funcao-${random_id.suffix.hex}"
  location = "us-central1"
}

resource "google_storage_bucket_object" "funcao_code" {
  name   = "codigo-funcao.zip"
  bucket = google_storage_bucket.funcao_bucket.name
  source = "codigo-funcao.zip"
}

resource "google_cloudfunctions_function" "welcome_function" {
  name        = "welcome-function"
  runtime     = "nodejs16"
  entry_point = "welcomeMessage"
  region      = "us-central1"

  source_archive_bucket = google_storage_bucket.funcao_bucket.name
  source_archive_object = google_storage_bucket_object.funcao_code.name
  trigger_http          = true
  available_memory_mb   = 128
}

resource "random_id" "suffix" {
  byte_length = 4
}
