require 'grape-swagger'
module V1
  class Base < Grape::API
    mount V1::Sessions
    mount V1::Users
    mount V1::Images

    add_swagger_documentation(
      api_version: 'v1',
      hide_documentation_path: true,
      mount_path: '/v1/docs',
      hide_format: true,
      info: {
        title: 'Tesmem API documentation',
        description: 'A description of the API.'
      }
    )
  end
end
