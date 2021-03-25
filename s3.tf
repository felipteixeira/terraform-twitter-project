# bucket cache codebuild
resource "aws_s3_bucket" "build_cache" {
  bucket = "build-cache-techtr00"
  acl    = "private"

  tags = {
    Name        = "Bucket Cache"
    Account     = local.prefix
    Environment = local.domain
  }

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.build_cache.id

  block_public_acls = true
  ignore_public_acls = true
  block_public_policy = true
  restrict_public_buckets = true
}
