ActiveAdmin.register SubCategory do
  searchable_select_options(scope: lambda do |params| 
                                params[:type].eql?('frame') ? SubCategory.where(title: 'frames') : 
                                ['svg', 'png'].include?(params[:type]) ? SubCategory.where.not(title: 'frames') :
                                SubCategory.all
                              end,
                              text_attribute: :title)
  menu priority: 3
  permit_params :title, :description, :category_id, :title_ar
  config.batch_actions = false

  filter :category_title, as: :string , label: 'Category'
  filter :title
  filter :title_ar
  filter :description

  controller do

    def destroy
      destroy! do |success, failure|
        failure.html do
          flash[:alert] = "The Deletion Failed Because " + resource.errors.full_messages[0][:message]
          super
        end
      end
    end
    
    # include ActionView::Helpers::TextHelper
    # def create
    #   @sub_category = SubCategory.new(sub_category_params)
    #   if @sub_category.save
    #     flash[:notice] = "Sub Category was successfully created!"
    #     redirect_to admin_sub_category_path(@sub_category)
    #   else
    #     flash[:alert] = ["#{pluralize(@sub_category.errors.count, "error")} prohibited this Sub Category from being saved! "]
    #     @sub_category.errors.full_messages.each do |msg|
    #       flash[:alert] << msg
    #     end
    #     redirect_to new_admin_sub_category_path
    #   end
    # end

    # private

    # def sub_category_params
    #   params.require(:sub_category).permit(:title, :description, :category_id, :title_ar)
    # end
  end
  

  index do
    column :id
    column :title
    column :title_ar
    column :description
    column :category
    column :stocks do |sub_category|
      sub_category.stocks.collect{|stock| stock.title}.join(', ').truncate(50)
    end
    column 'Templates' do |sub_category|
      templates = sub_category.designers.joins("inner join designs on designs.id = designers.design_id").select("designs.*")
      templates.collect{|template| template.title}.join(', ').truncate(50)
    end
    actions
  end

  show do
    attributes_table do
      row :id
      row :title
      row :title_ar
      row :description
      row :category
      row :stocks do |sub_category|
        sub_category.stocks.collect{|stock| stock.title}.join(', ').truncate(50)
      end
      row 'Templates' do |sub_category|
        templates = sub_category.designers.joins("inner join designs on designs.id = designers.design_id").select("designs.*")
        templates.collect{|template| template.title}.join(', ').truncate(50)
      end 
    end
  end

  form do |f|
    f.inputs do 
      # f.input :category, as: :searchable_select
      div style: 'display: block ruby;' do
        div do
          f.input(:category, as: :searchable_select, ajax: true)          
        end
        div do
          render :partial => 'admin/bootstrap_modals/category'
        end
      end
      f.input :title
      f.input :title_ar
      f.input :description
    end
    f.actions
  end

  
end
