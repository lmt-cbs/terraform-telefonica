# Generamos un random id cada vez que hagamos un cambio en el recurso para
# no machacarla cada vez

resource "random_id" "lambda_genBill_rand" {
    keepers = {
    lambda_genBill = "${var.lambda_genBill}"
    }

    byte_length = 8
}

resource "random_id" "lambda_getDisc_rand" {
    keepers = {
    lambda_getDisc = "${var.lambda_getDisc}"
    }

    byte_length = 8
}

resource "random_id" "nombre_role_rand" {
    keepers = {
    nombre_role = "${var.nombre_role}"
    }

    byte_length = 8
}

resource "random_id" "lambda_genCurrBill_rand" {
    keepers = {
    lambda_genCurrBill = "${var.lambda_genCurrBill}"
    }

    byte_length = 8
}
resource "random_id" "lambda_customer_rand" {
    keepers = {
    lambda_customer = "${var.lambda_customer}"
    }

    byte_length = 8
}

resource "random_id" "lambda_checkCustomer_rand" {
    keepers = {
    lambda_checkCustomer = "${var.lambda_checkCustomer}"
    }

    byte_length = 8
}

resource "random_id" "lambda_policy_cloudwatch_rand" {
    keepers = {
    lambda_policy_cloudwatch = "${var.lambda_policy_cloudwatch}"
    }

    byte_length = 8
}

resource "random_id" "cloudwatch_log_group_rand" {
    keepers = {
    cloudwatch_log_group = "${var.cloudwatch_log_group}"
    }

    byte_length = 8
}

resource "random_id" "dynamodb_table_rand" {
    keepers = {
    dynamodb_table = "${var.dynamodb_table}"
    }

    byte_length = 8
}

