require 'grape-swagger'
module V1
  class Base < Grape::API
    mount V1::Sessions
    mount V1::Users
    mount V1::Images
    mount V1::SuperCategories
    mount V1::Categories
    mount V1::SubCategories
    mount V1::Stocks
    mount V1::Designs
    mount V1::Folders
    mount V1::Templates
    mount V1::Containers
    mount V1::Trash
    mount V1::Uploads
    mount V1::Photos
    mount V1::Backgrounds
    mount V1::Animations
    mount V1::Icons
    mount V1::Unsplash
    mount V1::Triggers

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
