resource "aws_iam_role" "service_role" {
  name = "${local.prefix}-ServiceRole"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ecs-tasks.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "ecs_policy" {
  name       = "${local.prefix}-ECSFullAccess"
  roles      = [aws_iam_role.service_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"

  lifecycle {
    ignore_changes = [
      users,
      groups,
      roles,
    ]
  }
}

resource "aws_iam_policy_attachment" "ecr_policy" {
  name       = "${local.prefix}-ECRFullAccess"
  roles      = [aws_iam_role.service_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"

  lifecycle {
    ignore_changes = [
      users,
      groups,
      roles,
    ]
  }
}

resource "aws_iam_policy_attachment" "ecr_cloudwatch_policy" {
  name       = "${local.prefix}-ECRCloudWatchFullAccess"
  roles      = [aws_iam_role.service_role.name]
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"

  lifecycle {
    ignore_changes = [
      users,
      groups,
      roles,
    ]
  }
}

resource "aws_iam_role" "codebuild" {
  name = "${local.prefix}-CodebuildRole"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "codebuild-policy" {
  name       = "${local.prefix}-CodeBuildFullAccess"
  roles      = [aws_iam_role.codebuild.name]
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess"

  lifecycle {
    ignore_changes = [
      users,
      groups,
      roles,
    ]
  }
}

resource "aws_iam_policy_attachment" "cloudwatch-policy" {
  name       = "${local.prefix}-CloudWatchFullAccess"
  roles      = [aws_iam_role.codebuild.name]
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"

  lifecycle {
    ignore_changes = [
      users,
      groups,
      roles,
    ]
  }
}

resource "aws_iam_policy_attachment" "ssm_policy" {
  name       = "${local.prefix}-SsmFullAccess"
  roles      = [aws_iam_role.codebuild.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"

  lifecycle {
    ignore_changes = [
      users,
      groups,
      roles,
    ]
  }
}

resource "aws_iam_policy_attachment" "codebuild_ecr_policy" {
  name       = "${local.prefix}-CodeBuildECRFullAccess"
  roles      = [aws_iam_role.codebuild.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"

  lifecycle {
    ignore_changes = [
      users,
      groups,
      roles,
    ]
  }
}

resource "aws_iam_policy_attachment" "codebuild_ecs_policy" {
  name       = "${local.prefix}-CodeBuildECSFullAccess"
  roles      = [aws_iam_role.codebuild.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"

  lifecycle {
    ignore_changes = [
      users,
      groups,
      roles,
    ]
  }
}