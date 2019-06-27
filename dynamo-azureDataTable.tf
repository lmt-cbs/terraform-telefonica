resource "aws_dynamodb_table" "tf-mc-azure-table" {
  name = "tf-${terraform.workspace}-${var.dynamodb_table}-${random_id.dynamodb_table_rand.hex}"
  billing_mode ="PAY_PER_REQUEST"
  hash_key     = "stage"
  range_key    = "ob"

    attribute {
      name = "stage"
      type = "S"
    }

    attribute {
      name = "ob"
      type = "S"
    }

    global_secondary_index {
      name               = "${var.dynamodb_table}-index"
      hash_key           = "stage"
      range_key          = "ob"
      projection_type    = "KEYS_ONLY"
  }
 tags =  {
  "tf:${terraform.workspace}" = "tf-${terraform.workspace}"
  }
}
