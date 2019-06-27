# Autor       : luis Merino Troncoso
# F. Creacion : 12/06/2019
# Descripcion : Script terraform para la creacion de un Api gateway http que ataca
#               a una lambda Sencilla estilo "hello world" para ello utilizamos la 
#               funcionlidad workspace para separar los entornos de forma que 
#               cada uno sea el "stack" y utilizamos el swagger-desa.yaml para 
#               configurer el API de forma que no haya que escribir los metodos e 
#               intergracion a mano.
#               Tambien crea la tabla dynamo que gurardara las confiuraciones de 
#               cada ob al provisionar
#
#------------- Tareas a realizar en bash  ---------------------
#
# Instalar el cliente de aws ( awscli)
# configurar la autenticacion creando un profile con el nombre terransible 
#    $ aws configure --profile mc-azure-dev 
#
# introducir el ACCESS_KEY Y EL SECRET_ACCESS_KEY y la region del usuario de aws 
# despues de esto ya tenemos accesso al api
# No es conveniente hacer hard-coding de las claves en los scripts ni dejarlas
# en los nodos, es siempre preferible a traves de aws config o a traves de
# secrets
#
# podemos probar si funciona haciendo un listado de nuestros buckets
# 
#   $ aws s3 ls
#
# Despues tenemos  que crear el entorno (workspace) con el nombre 
# que queremos darle al stack ( en adelante Resource Group o RG) este nombre sera 
# el que pasara como parametro.
#
#   $terraform new workspace <nombre workspace>
#
# Despues hay que crear el bucket que contendra el zip de los fuentes de Lambda
#
#   $aws s3api create-bucket --bucket= <nombre workspace> --region=<region profile>
#
# Creamos el directorio que contendra codigo lambda de la funcion
# para las pruebas vamos a usar el nombre <example> 
#
#   $ mkdir example
#   $ cd example
#   $ vim main.js
#
# Editamos el fichero main.js y pegamos el codigo de la lambda de prueba
#--------- main.js ------------
# 'use strict'
#
# exports.handler = function(event, context, callback) {
#   var response = {
#   statusCode: 200,
#   headers: {
#      'Content-Type': 'text/html; charset=utf-8'
#   },
#   body: '<p>NUEVA VERSION <version de la lambda> - Lambda para probar Terraform y lambda</p>'
# }
#  callback(null, response)
#}
#------------------------
# Empaquetamos el main.js como example.zip de forma que sea el handler de nuestra lambda
#
#   $ zip ../example.zip main.js
#   $ cd ..
#
# subimos el zip del codigo de la lambda
#
#   $ aws s3 cp example.zip s3://<nombre workspace>/<version>/example.zip
#

# Creamos el script del root "REST API" gateway en el directorio <dir>
# con la funcion aws_api_gateway_rest_api
# Este es el contenedor de todos los demas objetos que vamos  crear despues.
# Permite exponer las lambdas 
# tiene una llamada a la funcion output de forma que una vez hecho el deploy
# nos devuelve la url de nuestro endPoint
#

# ---------------------------------------
# copiamos lambda.tf al mismo dir <terraform-mc>
# en este directorio inicializamos terraform con los parametros del backend en s3
#
#   $ terraform init \
#        -backend-config="tf-terraform-backend" \
#        -backend-config="region=us-west-2" \
#        -backend-config="key=terraform/terraform.tfstate"
#
# Ejecuamos terraform plan para hacer la simulacion de la instalacion
# es conveneinte guardar este fichero para tener el plan
# ejecutamos el apply para hacer la provision que nos devolvera la
# uri del endpoint

#
#  $ teraform plan -out <fichero>
#  $ terraform apply
#     uri para conexion : https://zgseykv778.execute-api.us-east-1.amazonaws.com/test

#-------------------- INICIO SCRIPT TERRAFORM --------------------- 

# Definimos las Variables de inicializacion del provider que en este caso es AWS
# toda variable que no se inicialice es pedida automaticamente por pantalla.
#
# Para la autenticacion utilizamos el profile de aws configure que hemos creado
# previamente con las claves para acceder al Api.

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# Para utilizar el estado remoto en S3 hay que inicializar el backend de forma que 
# nos pida por pantalla 

terraform {
  backend "s3" {}
}

# Creamos la variable app_version sin inicializar para que nos la pida en la 
# ejecucion esta variable nos permitira "simular" el Source Code version de 
# la lambda

variable "app_version" {
  type        = string
  description = "la version del codigo de la lambda, tiene que coincidir con el nombre del bucket creado ej: 1.0.0"
}

# Utilizamos variables de terraform del workspace que hemos creeado para nombrar
# el deployment , referenciar el bucket y la version
# muy importante los TAGS para los que utilizaremos tambien esta variable 
# para agrupar en el Resource group anterior todo lo que hemos creado dentro de este deployment
#   
#   terrasform.workspace

# inicializamos el api_gateway desde un template swagger

resource "aws_api_gateway_rest_api" "example" {
  name        = "tf-${terraform.workspace}"

  description = "Pruebas de API Gateway Serverless Con Terraform usando OpenApi Swagger file"
   body        = "${data.template_file.tf_aws_api_swagger.rendered}"
}

  data "template_file" "tf_aws_api_swagger" {
     template = "${file("swagger-desa.yaml")}"
     vars = {
       get_lambda_generateBilling_arn     = aws_lambda_function.genBill.invoke_arn
       get_lambda_generateCurrentBill_arn = aws_lambda_function.genCurrBill.invoke_arn
       get_lambda_getDiscount_arn         = aws_lambda_function.getDisc.invoke_arn
       get_lambda_customer_arn            = aws_lambda_function.customer.invoke_arn
       get_lambda_checkCustomer_arn       = aws_lambda_function.checkCustomer.invoke_arn 
     }
  }

resource "aws_api_gateway_deployment" "example" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  stage_name  = "desa"
}

resource "aws_api_gateway_stage" "example" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.example.id
  deployment_id = aws_api_gateway_deployment.example.id

  tags =  {
    "tf:${terraform.workspace}" = "tf-${terraform.workspace}"
  }
}

# esta url nos la dara al finalizar el terraform apply 

output "base_url" {
  value = aws_api_gateway_deployment.example.invoke_url
}
