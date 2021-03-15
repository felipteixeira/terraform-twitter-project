resource "aws_iam_role" "base_instance" {
  name = "${local.prefix}-RoleBase"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "profile_base" {
  name = "${local.prefix}-ProfileBase"
  role = aws_iam_role.base_instance.name
}

resource "aws_iam_policy_attachment" "ssm_instance" {
  name       = "${local.prefix}-EC2toSSM"
  roles      = [aws_iam_role.base_instance.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"

  lifecycle {
    ignore_changes = [
      users,
      groups,
      roles,
    ]
 }
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role" {
  role       = aws_iam_role.base_instance.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_policy_attachment" "ecs_instance" {
  name       = "${local.prefix}-ECSFullAccess"
  roles      = [aws_iam_role.base_instance.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"

  lifecycle {
    ignore_changes = [
      users,
      groups,
      roles,
    ]
  }
}
