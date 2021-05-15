resource "aws_s3_bucket" "website" {
  bucket        = var.website_domain
  force_destroy = true
  logging {
    target_bucket = aws_s3_bucket.website_logs.bucket
    target_prefix = "${var.website_domain}/"
  }
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  lifecycle {
    ignore_changes = [tags["Changed"]]
  }
}

resource "aws_s3_bucket_policy" "b" {
  bucket = aws_s3_bucket.website.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "website_public_read"
    Statement = [
      {
        Sid       = "website_read"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = [ "${aws_s3_bucket.website.arn}/*" ]
      }
    ]
  })
}

resource "aws_s3_bucket" "website_logs" {
  bucket        = "${var.website_domain}-logs"
  acl           = "log-delivery-write"
  force_destroy = true
  lifecycle {
    ignore_changes = [tags["Changed"]]
  }
}

resource "aws_s3_bucket_object" "site" {
  for_each = fileset("../site/", "*")
  bucket = aws_s3_bucket.website.id
  key    = each.value
  source = "../site/${each.value}"
  etag   = filemd5("../site/${each.value}")
  content_type = "text/html"
}