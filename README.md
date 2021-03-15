
### :page_with_curl: About
Construção de ambiente utilizando pipeline de entrega para coleta de tweets com as tags informadas pelo user.

Estrutura criada com terraform. 

###### `terraform init`
Para iniciar backend no bucket s3 e baixar as dependencias.

###### `terraform plan`
Verificar criação dos resources.

###### `terraform aaply --auto-approve`
Verificar criação dos recursos na cloud.

### :heavy_check_mark: Diagrama AWS

<p align="center">
  <img alt="" src="https://github.com/felipteixeira/terraform-twitter-project/blob/master/env/aws.png">
</p>