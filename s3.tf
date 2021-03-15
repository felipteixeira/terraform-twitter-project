# bucket cache codebuild
resource "aws_s3_bucket" "build-cache" {
  bucket = "build-cache-dev"
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
  bucket = aws_s3_bucket.build-cache.id

  # Block new public ACLs and uploading public objects
  block_public_acls = true

  # Retroactively remove public access granted through public ACLs
  ignore_public_acls = true

  # Block new public bucket policies
  block_public_policy = true

  # Retroactivley block public and cross-account access if bucket has public policies
  restrict_public_buckets = true
}
