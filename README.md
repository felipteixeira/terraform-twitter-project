
### :page_with_curl: About
Construção de ambiente utilizando pipeline de entrega para coleta de tweets com as tags informadas pelo user.

Estrutura criada com terraform. 

###### `terraform init`
Para iniciar backend no bucket s3 e baixar as dependencias.

###### `terraform plan`
Verificar criação dos resources.

###### `terraform apply --auto-approve`
Aplicar criação dos recursos na cloud.

Tecnologias utilizadas:
* NLB
* ASG
* CloudWatch
* S3
* EC2-ECS
* Codebuild
* ECR
* VPC

### :heavy_check_mark: Topologia para entrega da solução.

<p align="center">
  <img alt="" src="https://github.com/felipteixeira/terraform-twitter-project/blob/master/env/aws.png">
</p>

Para escrever a automação, utilizei dois repositórios privados no github.  
Sendo eles: [Aplicação](https://github.com/felipteixeira/twitter-app) e
[Terraform](https://github.com/felipteixeira/terraform-twitter-project)

* Redes:
    Foi criado uma VPC com o CIDR 10.5.0.0/16 e 4 subnets utilizando 2 availabity zones.
    public_subnets_cidr: ["10.5.0.0/24", "10.5.1.0/24"] subnets com rotas para IGW.
    private_subnets_cidr: ["10.5.3.0/24", "10.5.4.0/24"] para utilização a recursos internos.

* Security Group:
    Porta 8080 liberada para o bloco [0.0.0.0/0].
    Todos os protocolos liberados paras as redes: ["10.5.0.0/16"].


Billing aproximado para o projeto:

EC2 - t3.micro
Amazon Elastic Block Storage (EBS) pricing (monthly)
3.00 USD
Amazon EC2 Instance Savings Plans instances (monthly)
4.75 USD
Total monthly cost: 7.75 USD

CodeBuild - general1.small
20 builds per month x 5 minutes = 100.00 billed minutes (monthly)
100.00 minutes x 0.005 USD = 0.50 USD
AWS CodeBuild cost (monthly): 0.50 USD

Network Load Balancer
Total hourly charges for all Network Load Balancers (monthly)
16.43 USD
Total LCU charges for all Network Load Balancers (monthly)
0.06 USD
Total monthly cost: 16.49 USD

CloudWatch
Total monthly cost: 1.76 USD

