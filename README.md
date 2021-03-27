
# Twitter app

Construção de ambiente utilizando pipeline de entrega para coleta de tweets com as tags informadas pelo user.

## Arquitetura

![diagrama](./env/aws.png)

## AWS credentials

Use [aws-profile](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) to manage your credentials or another of your preference.

## Resources

| Name                                     | Description                                                     |
| ---------------------------------------- | --------------------------------------------------------------- |
| [env](./env)                             | resources to configure terraform S3 remote state and lock table |
| [keys](./keys)                           | shared resources used by applications                           |
| [modules](./modules)                     | reusable modules                                                |
| [base-backend](./base-backend.tf)        | you find all applications here                                  |
| [codebuild](./codebuild.tf)              | you find all applications here                                  |
| [ecs-cluster-policies](./ecs-cluster-policies.tf)        | you find all applications here                  |
| [ecs-cluster](./ecs-cluster.tf)          | you find all applications here                                  |
| [locals](./locals.tf)                    | you find all applications here                                  |
| [nlb](./nlb.tf)                          | you find all applications here                                  |
| [s3](./s3.tf)                            | you find all applications here                                  |
| [service-policies](./service-policies.tf)| you find all applications here                                  |
| [service-twitter-api](./service-twitter-api.tf)        | you find all applications here                    |
| [service-twitter-app](./service-twitter-app.tf)        | you find all applications here                    |
| [vars](./vars.tf)                        | you find all applications here                                  |
| [vpc](./vpc.tf)                          | you find all applications here                                  |


## Requirements

- [terraform cli 0.13.5](https://www.terraform.io/docs/cli/index.html) ([tfswitch](https://tfswitch.warrensbox.com) it's a good option)
- [checkov](https://www.checkov.io)
- [go](https://golang.org)
- [terratest](https://terratest.gruntwork.io/docs/)

## Deployment

There is a order to apply all resources:

1. backend
1. shared
1. applications

```
aws-vault exec <your-profile> -d 12h --

cd backend
terraform init
terraform plan -out plan.apply
terraform apply plan.apply

cd -
cd shared
terraform init
terraform plan -out plan.apply
terraform apply plan.apply

cd -
cd applications/nginx-app
terraform init
terraform workspace new stg
terraform workspace new prd
terraform plan -out plan.apply
terraform apply plan.apply

cd -
```


* Redes:
    Foi criado uma VPC com o CIDR 10.5.0.0/16 e 4 subnets utilizando 2 availabity zones.
    public_subnets_cidr: ["10.5.0.0/24", "10.5.1.0/24"] subnets com rotas para IGW.
    private_subnets_cidr: ["10.5.3.0/24", "10.5.4.0/24"] para utilização a recursos internos.

* Security Group:
    Porta 8080 liberada para o bloco [0.0.0.0/0].
    Todos os protocolos liberados paras as redes: ["10.5.0.0/16"].


