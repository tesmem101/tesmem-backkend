ActiveAdmin.register Design do
  menu priority: 4
  permit_params :title, :description, :styles, :user_id, :image, :height, :width, :is_trashed, :cat_id
  
  actions :all, except: [:new]

  filter :title
  filter :description
  filter :height
  filter :width
  filter :is_trashed, as: :select, collection: [0, 1], include_blank: false

  controller do
    include ActionView::Helpers::TextHelper
    include ActiveAdmin::SaveImage # if methods needed inside controller
    
    def update
      @design = Design.find(params[:id])
      if @design.update!(design_params)
        update_image(@design) if params[:design][:image]
        flash[:notice] = "Design was successfully created!"
        redirect_to admin_design_path(@design)
      else
        flash[:error] = ["#{pluralize(@design.errors.count, "error")} prohibited this design from being saved!"]
        @design.errors.full_messages.each do |msg|
          flash[:error] << msg
        end
        redirect_to new_admin_design_path
      end
    end

    private

    def design_params
      params.require(:design).permit(:title, :description, :user_id, :image, :height, :width, :is_trashed)
    end

  end
  

  index do
    column :id
    column :title
    column :description
    column :user
    column :image do |design|
      if Rails.env.development?
        image_tag "https://tesmem-production.s3.amazonaws.com#{design.image.url}", style: "max-width: 75px;"
      else
        image_tag design.image.url, style: "max-width: 75px;" if design.image.present?
      end
    end
    column :height
    column :width
    column :is_trashed
    column :container
    column 'Template' do |design|
      design.designer
    end
    actions
  end

  show do
    attributes_table do
      row :id
      row :title
      row :description
      row :user
      row :image do |design|
        if Rails.env.development?
          image_tag "https://tesmem-production.s3.amazonaws.com#{design.image.url}", style: "max-width: 75px;"
        else
          image_tag design.image.url, style: "max-width: 75px;" if design.image.present?
        end
      end
      row :height
      row :width
      row :is_trashed
      row :container
      row 'Template' do |design|
        design.designer
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :user, :as => :select, :collection => User.all.map {|u| [u.email, u.id]}, :include_blank => false
      f.input :title
      f.input :description
      if f.object.image.url
        f.input :image, as: :file, hint: image_tag(f.object.image.url, width: '100px', height: '100px')
      else
        f.input :image
      end
      f.input :height
      f.input :width
      f.input :is_trashed, as: :select, collection: [0, 1], include_blank: false
    end
    actions
  end
  
end
