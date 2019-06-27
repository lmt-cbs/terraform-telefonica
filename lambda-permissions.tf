# Los servicios de AWS no tienen acceso entre sí hasta que se otorga explícitamente.
# en terraform para las funciones Lambda, el acceso se concede mediante el
# recurso aws_lambda_permission definido mas abajo

resource "aws_lambda_permission" "apigw-genBill" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.genBill.arn
  principal     = "apigateway.amazonaws.com"

  #  /*/* permite accesso desde cualquier metodo o recurso dentro del API Gateway "REST API".
  source_arn = "${aws_api_gateway_deployment.example.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw-genDisc" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.getDisc.arn
  principal     = "apigateway.amazonaws.com"

  #  /*/* permite accesso desde cualquier metodo o recurso dentro del API Gateway "REST API".
  source_arn = "${aws_api_gateway_deployment.example.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw-customer" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.customer.arn
  principal     = "apigateway.amazonaws.com"

  #  /*/* permite accesso desde cualquier metodo o recurso dentro del API Gateway "REST API".
  source_arn = "${aws_api_gateway_deployment.example.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw-genCurrBill" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.genCurrBill.arn
  principal     = "apigateway.amazonaws.com"

  #  /*/* permite accesso desde cualquier metodo o recurso dentro del API Gateway "REST API".
  source_arn = "${aws_api_gateway_deployment.example.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw-checkCustomer" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.checkCustomer.arn
  principal     = "apigateway.amazonaws.com"

  #  /*/* permite accesso desde cualquier metodo o recurso dentro del API Gateway "REST API".
  source_arn = "${aws_api_gateway_deployment.example.execution_arn}/*/*"
}
