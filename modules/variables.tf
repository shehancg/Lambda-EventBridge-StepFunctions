variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "secret_arn" {
  description = "The ARN of the secret in AWS Secrets Manager"
  type        = string
}

variable "auth_url" {
  description = "The authentication URL for the token generation"
  type        = string
}

variable "company_code" {
  description = "The company code used for authentication"
  type        = string
}

variable "secret_prefix" {
  description = "The prefix for the secret keys in AWS Secrets Manager"
  type        = string
}

variable "api_key" {
  description = "The API key for the weather API"
}

variable "city" {
  description = "The city for which to get the weather"
}