module V1
    class CustomFonts < Grape::API
        include AuthenticateUser
        include V1Base
        version 'v1', using: :path
        resources :custom_fonts do
            desc 'Create Custom Font',
            { consumes: ['application/x-www-form-urlencoded'],
                http_codes: [
                 { code: 200, message: 'success' },
                 { code: RESPONSE_CODE[:forbidden], message: I18n.t('errors.forbidden') },
                 { code: RESPONSE_CODE[:unprocessable_entity], message: 'Validation error messages' },
                 { code: RESPONSE_CODE[:not_found], message: I18n.t('errors.not_found') },
               ] 
            }
            params do
                requires :file, type: String, desc: 'Custom Font File'
                requires :name, type: String, desc: 'Custom Font File Name'
            end
            post do
                custom_font = authenticate_user.custom_fonts.create!(name: params[:name], file: params[:file])
                if custom_font
                    render_success(CustomFontSerializer.new(custom_font), 'Custom Font Created/Uploaded')
                else
                    render_error(nil, 'Something Went Wrong :( ')
                end
            end

            desc 'Get All Custom Fonts of Current User',
            { consumes: ['application/x-www-form-urlencoded'],
                http_codes: [
                 { code: 200, message: 'success' },
                 { code: RESPONSE_CODE[:forbidden], message: I18n.t('errors.forbidden') },
                 { code: RESPONSE_CODE[:unprocessable_entity], message: 'Validation error messages' },
                 { code: RESPONSE_CODE[:not_found], message: I18n.t('errors.not_found') },
               ] 
            }
            get do
                custom_fonts = serialize_collection(authenticate_user.custom_fonts, serializer: CustomFontSerializer)
                render_success(custom_fonts, 'All Custom Fonts of Current User')
            end

            desc 'Delete Custom Font of Current User',
            { consumes: ['application/x-www-form-urlencoded'],
                http_codes: [
                 { code: 200, message: 'success' },
                 { code: RESPONSE_CODE[:forbidden], message: I18n.t('errors.forbidden') },
                 { code: RESPONSE_CODE[:unprocessable_entity], message: 'Validation error messages' },
                 { code: RESPONSE_CODE[:not_found], message: I18n.t('errors.not_found') },
               ] 
            }
            delete '/:id' do
                authenticate_user.custom_fonts.find(params[:id]).destroy
                render_success(nil, 'Custom Font Deleted')
            end

        end
    end
end