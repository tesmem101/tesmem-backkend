ActiveAdmin.register Designer do
  menu :label => "Templates", priority: 5
  permit_params :design_id, :category_id, :sub_category_id, :approved, :private, :url, :template_tags, :tags, :tag_ids
  
  filter :design
  filter :category
  filter :sub_category
  filter :approved
  filter :private
  filter :tags

  controller do
    include ActionView::Helpers::TextHelper
    include ActiveAdmin::SaveImage # if methods needed inside controller

    def create
      @template = Designer.new(template_params)
      if @template.save
        if params[:designer][:tag_ids].present?
          tag_ids = params[:designer][:tag_ids].reject { |id| (id == "" || id == " ")}
          tag_ids.each do |tag_id|
            TemplateTag.create(designer_id: @template.id, tag_id: tag_id )
          end
        end
        flash[:notice] = "Template Created!"
        redirect_to admin_designer_path(@template)
      else
        flash[:error] = ["#{pluralize(@template.errors.count, "error")} prohibited this template from being created!"]
        @stock.errors.full_messages.each do |msg|
          flash[:error] << msg
        end
        redirect_to new_admin_designer_path                    
      end
    end
    
    def update
      @template = Designer.find(params[:id])
      if @template.update(template_params)
        if params[:designer][:tag_ids].present?
          tag_ids = params[:designer][:tag_ids].reject { |id| (id == "" || id == " ")}
          tag_ids.each do |tag_id|
            TemplateTag.create(designer_id: @template.id, tag_id: tag_id )
          end
        end
        flash[:notice] = "Template Updated!"
        redirect_to admin_designer_path(@template)
      else
        flash[:error] = ["#{pluralize(@template.errors.count, "error")} prohibited this template from being updated!"]
        @stock.errors.full_messages.each do |msg|
          flash[:error] << msg
        end
        redirect_to new_admin_designer_path
      end

    end

    private

    def template_params
      params.require(:designer).permit(:design_id, :category_id, :sub_category_id, :approved, :private, :url, :template_tags, :tags, :tag_ids)
    end

  end

  index do
    column :id
    column :design
    column :category
    column :sub_category

    column :approved do |designer|
      designer.approved.eql?(true) ? 
      (check_box_tag 'approved_template', designer.id, checked = true, class: "current_user_#{current_user.id}") : 
      (check_box_tag 'approved_template', designer.id, checked = false, class: "current_user_#{current_user.id}")
    end
    column :private do |designer|
      designer.private.eql?(true) ? 
      (check_box_tag 'private_template', designer.id, checked = true, class: "current_user_#{current_user.id}") : 
      (check_box_tag 'private_template', designer.id, checked = false, class: "current_user_#{current_user.id}")
    end
    # column :url do |designer|
    #   designer.url ? designer.url.truncate(30) : nil
    # end
    column 'Image' do |designer|
      if Rails.env.development?
        image_tag "https://tesmem-production.s3.amazonaws.com#{designer.design.image.url}", style: "max-width : 75px;"
      else
        link_to (image_tag designer.design.image.url, style: "max-width : 75px;"), "#{ENV['FRONTEND_URL']}editor/Design/#{designer.design.id}"
      end
    end
    column :tags
    actions
  end

  show do
    attributes_table do
      row :id
      row :design
      row :category
      row :sub_category
      row :approved
      row :private
      # row :url
      row 'Image' do |designer|
        if Rails.env.development?
          image_tag "https://tesmem-production.s3.amazonaws.com#{designer.design.image.url}", style: "max-width : 75px;"
        else
          link_to (image_tag designer.design.image.url, style: "max-width : 75px;"), "#{ENV['FRONTEND_URL']}editor/Design/#{designer.design.id}"
        end
      end
      row :tags
    end
  end

  form do |f|
    f.inputs do
      f.input :design
      f.input :category
      f.input :sub_category
      f.input :approved
      f.input :private
      f.input :tags
    end
    actions
  end
  
end
