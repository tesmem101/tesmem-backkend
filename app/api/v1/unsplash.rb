module V1
    class Unsplash < Grape::API
      include AuthenticateRequest
      include V1Base
      include FetchUnsplash
      version "v1", using: :path
      resource :unsplash do
        desc 'Get all unsplash images',
             { consumes: ['application/x-www-form-urlencoded'],
               http_codes: [{ code: 200, message: 'success' }] }
        get '/' do
          search = params['search'].present? ? params['search'].downcase : nil
          unsplash_images = all_unsplash(search).map { |photo| map_unsplash_images(photo.table) }
          render_success(unsplash_images.as_json)
        end
      end
    end
  end
  