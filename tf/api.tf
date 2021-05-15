resource "aws_api_gateway_rest_api" "api" {
  name = "api"
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  depends_on = [
    aws_api_gateway_method.root,
    aws_api_gateway_integration.root,
    aws_api_gateway_method.site,
    aws_api_gateway_integration.site
  ]
}

resource "aws_api_gateway_stage" "site" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "site"
}

###
# ROOT METHOD
###
resource "aws_api_gateway_method" "root" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_rest_api.api.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "root" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_rest_api.api.root_resource_id
  http_method             = aws_api_gateway_method.root.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${aws_s3_bucket.website.id}.s3-website-${data.aws_region.current.name}.amazonaws.com"
  passthrough_behavior    = "WHEN_NO_MATCH"
}

resource "aws_api_gateway_method_response" "root_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_rest_api.api.root_resource_id
  http_method = aws_api_gateway_method.root.http_method
  status_code = "200"
}

###
# SITE METHOD
###

resource "aws_api_gateway_resource" "site" {
  path_part   = "{proxy+}"
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "site" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.site.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "site" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.site.id
  http_method             = aws_api_gateway_method.site.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${aws_s3_bucket.website.id}.s3-website-${data.aws_region.current.name}.amazonaws.com/{proxy}"
  passthrough_behavior    = "WHEN_NO_MATCH"
  request_parameters = {
    "integration.request.path.proxy" = "'method.request.path.proxy'"
  }
}

resource "aws_api_gateway_method_response" "site_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.site.id
  http_method = aws_api_gateway_method.site.http_method
  status_code = "200"
}


