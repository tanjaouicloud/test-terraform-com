variable "bucket_name" {
  type = string
}


variable "aws_access_key" {
  type        = string
  description = "AWS Access Key"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key"
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}
