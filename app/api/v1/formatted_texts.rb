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
                   formatted_text = user.formatted_texts.create(style: params[:style])
                   if formatted_text
                    render_success(FormattedTextSerializer.new(formatted_text))
                   else
                    render_error(RESPONSE_CODE[:internal_server_error], message: "Sorry! Something went wrong. Formatted Text not created yet!")
                   end
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

            get '/' do
                authenticate_user
                formatted_texts = serialize_collection(FormattedText.all, serializer: FormattedTextSerializer)
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