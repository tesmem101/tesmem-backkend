ActiveAdmin.register SubCategory do
  permit_params :title, :description, :category_id, :title_ar

  filter :category
  filter :title
  filter :title_ar
  filter :description
  

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

  
end
