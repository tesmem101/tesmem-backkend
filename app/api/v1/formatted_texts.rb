module V1
    class FormattedTexts < Grape::API
        include AuthenticateRequest
        include AuthenticateUser
        include V1Base
        version 'v1', using: :path

        resource :formatted_texts do
            desc 'Create Formatted Text',
            { consumes: ['application/x-www-form-urlencoded'],
             http_codes: [
              { code: 200, message: 'success' },
              { code: RESPONSE_CODE[:forbidden], message: I18n.t('errors.forbidden') },
              { code: RESPONSE_CODE[:unprocessable_entity], message: 'Validation error messages' },
              { code: RESPONSE_CODE[:not_found], message: I18n.t('errors.not_found') },
            ] }
            params do
                requires :style, type: JSON, desc: "Style Object"
            end
            post '/' do
                user = authenticate_user
                if user
                    formatted_texts = params[:style][:elements].collect{|element| user.formatted_texts.create(style: element)} 
                    formatted_texts = formatted_texts.collect {|text| text.style.merge!(formatted_text_id: text.id)}
                    render_success(formatted_texts, "Formatted Texts are created")
                end
            end

            desc 'Get All Formatted Text',
            { consumes: ['application/x-www-form-urlencoded'],
             http_codes: [
              { code: 200, message: 'success' },
              { code: RESPONSE_CODE[:forbidden], message: I18n.t('errors.forbidden') },
              { code: RESPONSE_CODE[:unprocessable_entity], message: 'Validation error messages' },
              { code: RESPONSE_CODE[:not_found], message: I18n.t('errors.not_found') },
            ] }

            params do
                requires :page, type: String, :desc => 'Page Number'
                requires :per_page, type: String, :desc => 'Number of elements on each page'
            end
            get '/' do
                authenticate_user
                formatted_texts = FormattedText.paginate(page: params[:page], per_page: params[:per_page]).collect {|text| text.style.merge!(formatted_text_id: text.id)}
                render_success(formatted_texts, "All Formatted Texts")
            end

            desc 'Get Single Formatted Text',
            { consumes: ['application/x-www-form-urlencoded'],
             http_codes: [
              { code: 200, message: 'success' },
              { code: RESPONSE_CODE[:forbidden], message: I18n.t('errors.forbidden') },
              { code: RESPONSE_CODE[:unprocessable_entity], message: 'Validation error messages' },
              { code: RESPONSE_CODE[:not_found], message: I18n.t('errors.not_found') },
            ] }

            get '/:id' do
                authenticate_user
                formatted_text = FormattedTextSerializer.new(FormattedText.find(params[:id]))
                render_success(formatted_text, "Single Formatted Text")
            end

            desc 'Delete Single Formatted Text',
            { consumes: ['application/x-www-form-urlencoded'],
             http_codes: [
              { code: 200, message: 'success' },
              { code: RESPONSE_CODE[:forbidden], message: I18n.t('errors.forbidden') },
              { code: RESPONSE_CODE[:unprocessable_entity], message: 'Validation error messages' },
              { code: RESPONSE_CODE[:not_found], message: I18n.t('errors.not_found') },
            ] }

            delete '/:id' do
                authenticate_user
                formatted_text = FormattedTextSerializer.new(FormattedText.find(params[:id]).delete)
                render_success(formatted_text, "Formatted Text Deleted now!")
            end

        end
    end
end