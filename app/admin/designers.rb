ActiveAdmin.register Designer, as: "Templates" do
  menu :label => "Templates", priority: 5
  permit_params :design_id, :category_id, :sub_category_id, :approved, :private, :url, :template_tags, :tags, :tag_ids
  # action_item :new, only: :index do
  #   link_to('New Template', new_admin_designer_path)
  # end
  
  filter :design_title, as: :string , label: 'Design'
  # filter :category_title, as: :string , label: 'Category'
  filter :sub_category_title, as: :string , label: 'Sub category'
  filter :approved
  filter :private
  filter :tags_name, as: :string , label: 'Tags'

  controller do
    include ActionView::Helpers::TextHelper
    include ActiveAdmin::SaveImage # if methods needed inside controller

    def create
      @template = Designer.new(template_params)
      @template.category_id = Category.find_by(title: 'RESERVED_DESIGNS').id
      if @template.save
        if params[:designer][:tag_ids].present?
          tag_ids = params[:designer][:tag_ids].reject { |id| (id == "" || id == " ")}
          tag_ids.each do |tag_id|
            TemplateTag.create(designer_id: @template.id, tag_id: tag_id )
          end
        end
        flash[:notice] = "Template Created!"
        redirect_to admin_template_path(@template)
      else
        flash[:alert] = ["#{pluralize(@template.errors.count, "error")} prohibited this template from being created!  " ]
        @template.errors.full_messages.each do |msg|
          flash[:alert] << msg
        end
        redirect_to new_admin_template_path                    
      end
    end
    
    def update
      @template = Designer.find(params[:id])
      if @template.update(template_params)
        if params[:designer][:tag_ids].present?
          @template.tags.destroy_all
          tag_ids = params[:designer][:tag_ids].reject { |id| (id == "" || id == " ")}
          tag_ids.each do |tag_id|
            TemplateTag.create(designer_id: @template.id, tag_id: tag_id )
          end
        end
        flash[:notice] = "Template Updated!"
        redirect_to admin_template_path(@template)
      else
        flash[:alert] = ["#{pluralize(@template.errors.count, "error")} prohibited this template from being updated!  "]
        @template.errors.full_messages.each do |msg|
          flash[:alert] << msg
        end
        redirect_to new_admin_template_path
      end

    end

    private

    def template_params
      params.require(:designer).permit(:design_id, :category_id, :sub_category_id, :approved, :private, :url, :template_tags, :tags, :tag_ids)
    end

  end

  index  do
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
      # debugger
      if Rails.env.development?
        image_tag "https://tesmem-production.s3.amazonaws.com#{designer.design.image.url}", style: "max-width : 75px;"
      else
        link_to (image_tag designer.design.image.url, style: "max-width : 75px;"), "#{ENV['FRONTEND_URL']}editor/Design/#{designer.design.id}"
      end
    end
    column :tags
    actions
  end

  show :title => proc {|template| "Template # #{template.id}" } do
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
      f.input :design, as: :searchable_select
      # f.input :category, as: :searchable_select
      f.input :sub_category, as: :searchable_select
      f.input :approved
      f.input :private
      f.input :tags, as: :searchable_select
    end
    actions
  end
  
end
