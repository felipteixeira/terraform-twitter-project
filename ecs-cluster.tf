module "ecs_twitter_app" {
  source = "./modules/ecs-cluster"

  #Cluster
  cluster_name = "${local.prefix}-ecs-cluster"

  #Launch Config
  instance_type        = "t3.micro"
  user_data            = file("./env/userdata/default_userdata.tpl")
  key_name             = aws_key_pair.ecs_key.id
  ami_id               = "ami-082b5e21a65801c67"
  security_groups      = [aws_security_group.twitter-app_sg.id]
  iam_instance_profile = aws_iam_instance_profile.profile_base.id

  #Autoscaling Group
  desired_capacity = 1
  max_instance     = 2
  subnets_id       = [module.vpc.private_subnet_ids[0], module.vpc.private_subnet_ids[1]]
}

resource "aws_key_pair" "ecs_key" {
  key_name   = "${local.prefix}-ecs-key"
  public_key = file("keys/${local.prefix}-ecs-key.pem.pub")
}

resource "aws_security_group" "twitter-app_sg" {
  name        = "${local.prefix}-sg-twitter-app"
  description = "Security group do twitter-app."
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Public access"
  }

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["10.5.0.0/24"]
    description = "Private access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "${local.prefix}-sg-twitter-app"
    Ambiente = local.environment
  }
}
