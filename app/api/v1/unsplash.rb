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
          unsplash_images = []
          page_limit = 3
          for page_number in 1..page_limit do
            unsplash_images.concat get_unsplash_images(search, page_number, nil, 30, 'latest').map { |photo| map_unsplash_images(photo.table, 'full') }
          end
          records = get_unsplash_response(unsplash_images)
          render_success(records.as_json)
        end
      end
    end
  end
  