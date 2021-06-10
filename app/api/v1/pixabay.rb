module V1
    class Pixabay < Grape::API
        include FetchPixabay
        include V1Base
        version "v1", using: :path
        resource :pixabay do

            desc 'Get all Pixabay Images'
            get '/' do
                

                    if params[:page].present? && params[:per_page].present?
                        search = params['search'].present? ? params['search'].downcase : nil
                        if params[:is_arabic].present? && params[:is_arabic].eql?('true')
                            params.delete :is_arabic
                            detection = googleCloudTranslation.detect search # Detect Language
                            translation = googleCloudTranslation.translate search, from: detection.language, to: "en"
                            search = translation.text
                        end

                        if search
                            params.delete :search
                            params[:q] = search
                        end

                        begin
                            pixabay_response = PixabayManager::Pixabay.photos(params)['hits'].map { |photo| map_pixabay_images(photo) }
                            records = get_pixabay_response(pixabay_response)
                            render_success(records)                    
                        rescue => exception
                            render_error(RESPONSE_CODE[:unprocessable_entity], exception)
                        end

                    else
                        render_error(RESPONSE_CODE[:bad_request], 'Sorry! You should pass page and per_page params!')
                    end

            end
        end
    end
end