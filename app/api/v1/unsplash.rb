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
          for page_number in 1..3 do
            unsplash_images.concat all_unsplash(search, page_number).map { |photo| map_unsplash_images(photo.table) }
          end
          records = get_unsplash_response(unsplash_images)
          render_success(records.as_json)
        end
      end
    end
  end
  