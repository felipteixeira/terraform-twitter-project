
# Twitter app

Construção de ambiente utilizando pipeline de entrega para coleta de tweets com as tags informadas pelo user.

## Architecture

![diagrama](./env/aws.png)

## AWS credentials

Utilize [aws-profile](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) para gerenciar as credenciais ou outro de sua preferencia.

## Resources

| Name                                     | Description                                                     |
| ---------------------------------------- | --------------------------------------------------------------- |
| [env](./env)                             | Pasta contendo diagram e script de instalação de recursos na ec2|
| [keys](./keys)                           | Pasta contendo chave publica para criação de chave pem na aws   |
| [modules](./modules)                     | Pasta contendo modulos para criação de recursos na aws          |
| [base-backend](./base-backend.tf)        | Configuração state back-end no bucket s3                        |
| [codebuild](./codebuild.tf)              | Criação de codebuild para deploy automatizado                   |
| [ecs-cluster-policies](./ecs-cluster-policies.tf)|Criação de policies de acesso para cluster ecs           |
| [ecs-cluster](./ecs-cluster.tf)          | Criação do cluster ecs                                          |
| [locals](./locals.tf)                    | Arquivo locals contendo configuração de ambiente                |
| [nlb](./nlb.tf)                          | Criação de Network Load Balance                                 |
| [s3](./s3.tf)                            | Criação de bucket s3 para armazenar logs de build               |
| [service-policies](./service-policies.tf)| Criação de policies para serviços                               |
| [service-twitter-api](./service-twitter-api.tf)| Service twitter-api                                       |
| [service-twitter-app](./service-twitter-app.tf)| Service twitter-app                                       |
| [vars](./vars.tf)                        | Variaveis de ambiente                                           |
| [vpc](./vpc.tf)                          | Vpc                                                             |


## Requirements

- [terraform cli 0.13.5](https://www.terraform.io/docs/cli/index.html) ([tfswitch](https://tfswitch.warrensbox.com) é uma boa opção)

## Workspaces

- prod

## Deploy

```
terraform workspace new prod
terraform init
terraform plan -out plan.apply
terraform apply plan.apply

```