module V1
    class Triggers < Grape::API
      include AuthenticateRequest
      include V1Base
      include FetchUnsplash
      version "v1", using: :path
      resource :Triggers do
        desc 'Triggers Track downloads on unsplash images',
             { consumes: ['application/x-www-form-urlencoded'],
               http_codes: [{ code: 200, message: 'success' }] }
        get '/' do
          photoid = params['photoid'].present? ? params['photoid'] : nil
          getimage = track_unsplash_download(photoid)
          records = getimage
          
          render_success(records.as_json)
        end
      end
    end
  end
  