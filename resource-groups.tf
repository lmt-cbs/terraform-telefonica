# Creamos el Resource Group (agrupacion Simil stack) para incluir todos los recursos
# que pertenezcan al deployment , lo creamos con el mismo nombre del entorno

resource "aws_resourcegroups_group" "telef-mc-rg" {
  name = "tf-${terraform.workspace}"

  resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::AllSupported"
  ],
  "TagFilters": [
    {
      "Key": "tf:${terraform.workspace}",
      "Values": ["tf-${terraform.workspace}"]
    }
  ]
}
JSON
  }
}
