module V1
    class Unsplash < Grape::API
      include AuthenticateRequest
      include V1Base
      include FetchUnsplash
      require "google/cloud/translate/v2"
      version "v1", using: :path
      resource :unsplash do
        desc 'Get all unsplash images',
             { consumes: ['application/x-www-form-urlencoded'],
               http_codes: [{ code: 200, message: 'success' }] }
        params do
          requires :page, type: String, :desc => 'Page Number'
          requires :per_page, type: Integer, :desc => 'Number of elements on each page'
        end
        get '/' do
          if params[:page].present? && params[:per_page].present?
            search = params['search'].present? ? params['search'].downcase : nil
            unsplash_images = []
            if params[:is_arabic].present? && params[:is_arabic].eql?('true')
              detection = googleCloudTranslation.detect search # Detect Language
              translation = googleCloudTranslation.translate search, from: detection.language, to: "en"
              search = translation.text
            end
            unsplash_images.concat get_unsplash_images(search, params[:page], nil, params[:per_page], 'latest').map { |photo| map_unsplash_images(photo.table, 'regular') }
            records = get_unsplash_response(unsplash_images)
            render_success(records.as_json)
          else
            render_error(RESPONSE_CODE[:bad_request], 'Sorry! You should pass page and per_page params!')
          end
        end
      end
    end
  end
  