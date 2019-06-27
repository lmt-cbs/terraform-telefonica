# Gestion de secrets , solo creado por ver funcionamiento

resource "aws_secretsmanager_secret" "tf-secret" {
  name = "tf-${terraform.workspace}-secret"

tags =  {
    "tf:${terraform.workspace}" = "tf-${terraform.workspace}"
  }
}
