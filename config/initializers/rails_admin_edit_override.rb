
require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
    module Config
      module Actions
        class Edit < RailsAdmin::Config::Actions::Base
          RailsAdmin::Config::Actions.register(self)
  
          register_instance_option :member do
            true
          end
  
          register_instance_option :http_methods do
            [:get, :put]
          end
  
          register_instance_option :controller do
            proc do
              if request.get? # EDIT

                respond_to do |format|
                  format.html { render @action.template_name }
                  format.js   { render @action.template_name, layout: false }
                end
  
              elsif request.put? # UPDATE
                sanitize_params_for!(request.xhr? ? :modal : :update)                  
                SortReservedIcon.find_by(position: params[:sort_reserved_icon][:position]).update(position: @object.position) if @abstract_model.model_name.eql?("SortReservedIcon")
                @object.set_attributes(params[@abstract_model.param_key])
                @authorization_adapter && @authorization_adapter.authorize(:update, @abstract_model, @object)
                changes = @object.changes
                if @abstract_model.model_name.eql?("FormattedText")
                  if @object.approved && changes.present? && changes["approved"].present? && !changes["approved"][0]
                    @object.approvedBy_id = current_user.id 
                    @object.unapprovedBy_id = nil
                  end

                  if !@object.approved && changes.present? && changes["approved"].present? && changes["approved"][0]
                    @object.unapprovedBy_id = current_user.id 
                    @object.approvedBy_id = nil
                  end
                end
                if @object.save
                  @auditing_adapter && @auditing_adapter.update_object(@object, @abstract_model, _current_user, changes)
                  respond_to do |format|
                    format.html { redirect_to_on_success }
                    format.js { render json: {id: @object.id.to_s, label: @model_config.with(object: @object).object_label} }
                  end
                else
                  handle_save_error :edit
                end
  
              end
            end
          end
  
          register_instance_option :link_icon do
            'icon-pencil'
          end
        end
      end
    end
  end