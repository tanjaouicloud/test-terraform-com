resource "aws_s3_bucket" "secure_bucket" {
  bucket = var.bucket_name
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "arn:aws:kms:us-east-1:111122223333:key/abcd-1234"
        sse_algorithm     = "aws:kms"
      }
    }
  }
}