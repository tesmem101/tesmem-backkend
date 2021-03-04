# frozen_string_literal: true

class ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    if resource.errors.empty?
      set_flash_message(:notice, :confirmed) if is_navigational_format?
      sign_in(resource_name, resource)
      domain = request.port.blank? ? request.protocol + request.host : request.protocol + request.host_with_port   #"http://#{request.host}:#{request.port}"
      redirect_to ENV['FRONTEND_URL']
      # respond_with_navigational(resource){ redirect_to domain }
    else
      render json: {status: 422, mesage: 'Sorry! Something went wrong!', errors: resource.errors}
      # super
      # respond_with_navigational(resource.errors, :status => :unprocessable_entity){ render_with_scope :new }
    end
  end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end
end
