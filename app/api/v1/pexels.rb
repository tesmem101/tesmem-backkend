module V1
    class Pexels < Grape::API
        include V1Base
        include FetchPexel
        require 'pexels'
        require "google/cloud/translate/v2"
        version "v1", using: :path
        resource :pexels do

            desc 'Get all Pexels Images'
            get '/' do
                
                if params[:page].present? && params[:per_page].present?
                    search = params['search'].present? ? params['search'].downcase : nil
                    pexel_images = []
                    if params[:is_arabic].present? && params[:is_arabic].eql?('true')
                      detection = googleCloudTranslation.detect search # Detect Language
                      translation = googleCloudTranslation.translate search, from: detection.language, to: "en"
                      search = translation.text
                    end
                    pexel_images = []
                    pexel_images.concat get_pexel_images(search, params[:page], params[:per_page]).map { |photo| map_pexel_images(photo) }
                    pexel_images = get_pexel_response(pexel_images)
                    render_success(pexel_images.as_json)
                else
                    render_error(RESPONSE_CODE[:bad_request], 'Sorry! You should pass page and per_page params!')
                end

            end
        end
    end
end