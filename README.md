# terraform-telefonica
repo con los scripts de terraform para el api gateway

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

# Instalar el cliente de aws ( awscli)
# configurar la autenticacion creando un profile con el nombre terransible
#    $ aws configure --profile mc-azure-dev

# introducir el ACCESS_KEY Y EL SECRET_ACCESS_KEY y la region del usuario de aws
# despues de esto ya tenemos accesso al api
# No es conveniente hacer hard-coding de las claves en los scripts ni dejarlas
# en los nodos, es siempre preferible a traves de aws config o a traves de
# secrets

# podemos probar si funciona haciendo un listado de nuestros buckets
#
#   $ aws s3 ls

# Despues tenemos  que crear el entorno (workspace) con el nombre
# que queremos darle al stack ( en adelante Resource Group o RG) este nombre sera
# el que pasara como parametro.

#   $terraform new workspace <nombre workspace>

# Despues hay que crear el bucket que contendra el zip de los fuentes de Lambda

#   $aws s3api create-bucket --bucket= <nombre workspace> --region=<region profile>

# Creamos el directorio que contendra codigo lambda de la funcion
# para las pruebas vamos a usar el nombre <example>

#   $ mkdir example
#   $ cd example
#   $ vim main.js

# Empaquetamos el main.js como example.zip de forma que sea el handler de nuestra lambda

#   $ zip ../example.zip main.js
#   $ cd ..

# subimos el zip del codigo de la lambda

#   $ aws s3 cp example.zip s3://<nombre workspace>/<version>/example.zip


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

#   $ terraform init \
#        -backend-config="tf-terraform-backend" \
#        -backend-config="region=us-west-2" \
#        -backend-config="key=terraform/terraform.tfstate"

# Ejecuamos terraform plan para hacer la simulacion de la instalacion
# es conveneinte guardar este fichero para tener el plan
# ejecutamos el apply para hacer la provision que nos devolvera la
# uri del endpoint


#  $ teraform plan -out <fichero>
#  $ terraform apply
#     uri para conexion : https://zgseykv778.execute-api.us-east-1.amazonaws.com/test


                                                                          1,1           Top
