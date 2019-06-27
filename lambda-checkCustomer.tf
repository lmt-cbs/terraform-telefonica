# Creacion del recurso Lambda que coresponde con la llamada a checkCustomer.
#
# el codigo va en zip y se almacena en la carpeta de del bucket s3 creado

resource "aws_lambda_function" "checkCustomer" {
  function_name = "tf-${terraform.workspace}-${var.lambda_checkCustomer}-${random_id.lambda_checkCustomer_rand.hex}"

# El nombre y carpeta del bucket este nombre coincidira con el del workspace

  s3_bucket = "tf-${terraform.workspace}"
  s3_key    = "v${var.app_version}/example.zip"

# Ahora tenemos que asignar el nombre del fichero "main" dentro del zip file
# (main.js) al "handler" dinde fue creado function.

  handler = "main.handler"
  runtime = "nodejs8.10"

  role = aws_iam_role.lambda_exec.arn

  tags =  {
    "tf:${terraform.workspace}" = "tf-${terraform.workspace}"
  }

}
