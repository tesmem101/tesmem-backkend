ActiveAdmin.register Upload do
  menu  priority: 8
  permit_params :user_id, :image, :title, :is_trashed
  config.batch_actions = false
  filter :user, collection: -> {
    User.all.map {|user| [user.email, user.id]}
  }, as: :searchable_select
  filter :title
  filter :is_trashed

  controller do
    include ActionView::Helpers::TextHelper
    include ActiveAdmin::SaveImage # if methods needed inside controller
    def create
      @upload = Upload.new(upload_params)
      if @upload.save
        insert_image(@upload)
        flash[:notice] = "Upload was successfully created!"
        redirect_to admin_upload_path(@upload)
      else
        flash[:error] = ["#{pluralize(@upload.errors.count, "error")} prohibited this upload from being saved!"]
        @upload.errors.full_messages.each do |msg|
          flash[:error] << msg
        end
        redirect_to new_admin_upload_path
      end
    end

    def update
      @upload = Upload.find(params[:id])
      if @upload.update(upload_params)
        if params[:upload][:image]
          update_image(@upload)
        end
        flash[:notice] = "Upload was successfully updated!"
        redirect_to admin_upload_path(@upload)
      else
        flash[:error] = ["#{pluralize(@upload.errors.count, "error")} prohibited this upload from being updated!"]
        @upload.errors.full_messages.each do |msg|
          flash[:error] << msg
        end
        redirect_to edit_admin_upload_path
      end

    end


    private

    def upload_params
      params.require(:upload).permit(:user_id, :image, :title, :is_trashed)
    end
  end

  index do
    column :id
    column :title
    column :user
    column :image do |upload|
      image_tag upload.image.url, style: "max-width: 75px;" if upload.image.present?  
    end
    column :is_trashed
    actions
  end

  show do
    attributes_table do
      row :id
      row :title
      row :user
      row :image do |upload|
        image_tag upload.image.url, style: "max-width: 75px;" 
      end
      row :is_trashed
    end
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :user, :as => :select, :collection => User.all.map {|u| [u.email, u.id]}, as: :searchable_select

      if f.object.image.url
        f.input :image, as: :file, hint: image_tag(f.object.image.url, width: '100px', height: '100px')
      else
        f.input :image
      end
      if !f.object.new_record? 
        f.input :is_trashed
     end
    end
    actions
  end
  
end
