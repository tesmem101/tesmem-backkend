module V1
  class Users < Grape::API
    include AuthenticateRequest
    include V1Base
    version 'v1', using: :path

    resource :users do
    end
  end
end
