module "code_build_twitter_app" {
  source = "./modules/codebuild"

  build_name      = "twitter-app"
  service_role    = aws_iam_role.codebuild.arn
  source_location = var.GIT_REPO_TWITTER_APP
  git_branch      = "master"
  env_image       = "aws/codebuild/standard:3.0"
  cache_bucket    = aws_s3_bucket.build_cache.bucket
}

module "code_build_twitter_api" {
  source = "./modules/codebuild"

  build_name      = "twitter-api"
  service_role    = aws_iam_role.codebuild.arn
  source_location = var.GIT_REPO_TWITTER_API
  git_branch      = "master"
  env_image       = "aws/codebuild/standard:3.0"
  cache_bucket    = aws_s3_bucket.build_cache.bucket
}
