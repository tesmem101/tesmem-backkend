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

            get '/' do
                authenticate_user
                formatted_texts = FormattedText.all.collect {|text| text.style.merge!(formatted_text_id: text.id)}
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

            desc 'Change Approved field status',
            { consumes: ['application/x-www-form-urlencoded'],
             http_codes: [
              { code: 200, message: 'success' },
              { code: RESPONSE_CODE[:forbidden], message: I18n.t('errors.forbidden') },
              { code: RESPONSE_CODE[:unprocessable_entity], message: 'Validation error messages' },
              { code: RESPONSE_CODE[:not_found], message: I18n.t('errors.not_found') },
            ] }

            put 'change_approved_status/:id' do
                user_id = params[:user_id].split("_")[-1]
                text = FormattedText.find(params[:id])
                if params[:approved].eql?("true")
                    text.update(approved: params[:approved], approvedBy_id: user_id, unapprovedBy_id: nil)                    
                else
                    text.update(approved: params[:approved], unapprovedBy_id: user_id, approvedBy_id: nil)   
                end
                render_success(user_id, "Formatted Text Updated!")
            end

        end
    end
end