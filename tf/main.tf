data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_route53_zone" "domain" {
  name         = var.website_domain
  private_zone = false
}

data "aws_acm_certificate" "wildcard_website" {
  domain      = "*.${var.website_domain}"
  statuses    = ["ISSUED"]
  most_recent = true
}

variable "website_domain" {
  default = "thealexhatcher.com"
}

variable "environment" {
  default = "dev"
}