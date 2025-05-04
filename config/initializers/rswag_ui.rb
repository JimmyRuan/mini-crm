Rswag::Ui.configure do |c|

  # List the Swagger endpoints that you want to be documented through the
  # swagger-ui. The first parameter is the path where the Swagger documentation will be served
  # The second parameter is the path to the Swagger specification file
  # NOTE: If you're using rspec-api to expose Swagger files
  # (under openapi_root) as JSON or YAML endpoints, then the list below should
  # correspond to the relative paths for those endpoints.

  c.openapi_endpoint '/api-docs/v1/swagger.yaml', 'API V1 Docs'

  # Add Basic Auth in case your API is private
  # c.basic_auth_enabled = true
  # c.basic_auth_credentials 'username', 'password'
end
