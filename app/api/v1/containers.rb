module V1
  class Containers < Grape::API
    include AuthenticateUser
    include V1Base
    version 'v1', using: :path

    resource :containers do

      desc 'Add Desgin/image to folders',
           { consumes: ['application/x-www-form-urlencoded'],
            http_codes: [
             { code: 200, message: 'success' },
             { code: RESPONSE_CODE[:forbidden], message: I18n.t('errors.forbidden') },
             { code: RESPONSE_CODE[:unprocessable_entity], message: 'Validation error messages' },
             { code: RESPONSE_CODE[:not_found], message: I18n.t('errors.not_found') },
           ] }
      params do
        requires :folder_id, type: Integer, desc: 'Folder id'
        requires :instance_id, type: Integer, desc: 'instance id'
        requires :instance, type: String, desc: 'instance type'
      end
      post :create do
        instance = nil
        if params[:instance] == 'design'
          instance = authenticate_user.designs.find(params[:instance_id])
        elsif params[:instance] == 'upload'
          instance = authenticate_user.uploads.find(params[:instance_id])
        end
        render_error(RESPONSE_CODE[:unauthorized], message: I18n.t('errors.not_found')) if !instance

        user_folder = authenticate_user.folders.find(params[:folder_id])
        container = Container.find_or_initialize_by(instance_id: params[:instance_id])

        serialization = nil
        if container.update(folder_id: params[:folder_id])
          serialization = ContainerSerializer.new(container)
        else
          new_container = Container.create(instance: instance, folder_id: params[:folder_id])
          serialization = ContainerSerializer.new(new_container)
        end
        render_success(serialization.as_json)
      end
      desc 'Move Designs/Images to other folder',
           { consumes: ['application/x-www-form-urlencoded'],
            http_codes: [
             { code: 200, message: 'success' },
             { code: RESPONSE_CODE[:forbidden], message: I18n.t('errors.forbidden') },
             { code: RESPONSE_CODE[:unprocessable_entity], message: 'Validation error messages' },
             { code: RESPONSE_CODE[:not_found], message: I18n.t('errors.not_found') },
           ] }
      params do
        requires :id, type: Integer, desc: 'Instance Id'
        requires :folder_id, type: Integer, desc: "Folder id"
      end
      put '/:id' do
        container = Container.find(params[:id])
        user_folder = authenticate_user.folders.find(container.folder_id)
        if container.update(params)
          serialization = ContainerSerializer.new(container)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:unprocessable_entity], container.errors.full_messages.join(', '))
        end
      end
      desc "Remove design/image from folder",
           { consumes: ["application/x-www-form-urlencoded"],
             http_codes: [{ code: 200, message: "success" }] }
      params do
        requires :id, type: Integer, desc: 'id'
      end
      delete "/:id" do
        container = Container.find(params[:id])
        user_folder = authenticate_user.folders.find(container.folder_id)
        if user_folder
          container.destroy
          render_success("Instance is deleted".as_json)
        else
          render_error(RESPONSE_CODE[:unauthorized], message: I18n.t('errors.not_found'))
        end
      end
    end
  end
end