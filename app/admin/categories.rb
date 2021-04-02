ActiveAdmin.register Category do
  menu priority: 2
  permit_params :id, :title, :description, :cover, :title_ar, :width, :height, :unit, :super_category_id, :sub_category_id
  config.batch_actions = false
  filter :title
  filter :title_ar
  filter :description
  filter :super_category_title, as: :string , label: 'Super category'
  filter :width
  filter :height
  filter :unit

  controller do
    def destroy
      destroy! do |success, failure|
        failure.html do
          flash[:alert] = "The Deletion Failed Because " + resource.errors.full_messages[0][:message]
          super
        end
      end
    end
  end

  index do
    column :id
    column :title
    column 'Arabic Title' do |category|
      category.title_ar
    end
    column :description
    # column :width
    # column :height
    # column :unit
    column 'Super Category' do |category|
      category.super_category
    end
    column :cover do |category|
      category.image.present? ? image_tag(category.image.url, style: "max-width: 75px;") : nil
    end
    column 'Sub Categories' do |category|
      category.sub_categories.collect{|sub_category| sub_category.title}.join(', ').truncate(25)
    end
    column 'Stocks' do |category|
      category.stocks.collect{|stock| stock.title}.join(', ').truncate(25)
    end
    actions
  end  

  show do
    attributes_table do
      row :id
      row :title
      row 'Arabic Title' do |category|
        category.title_ar
      end
      row :description
      row :width
      row :height
      row :unit
      row 'Super Category' do |category|
        category.super_category
      end
      row :cover do |category|
        category.image.present? ? image_tag(category.image.url, style: "max-width: 75px;") : nil
      end
      row 'Sub Categories' do |category|
        category.sub_categories.collect{|sub_category| sub_category.title}.join(', ').truncate(25)
      end
      row 'Stocks' do |category|
        category.stocks.collect{|stock| stock.title}.join(', ').truncate(25)
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :title_ar
      f.input :description
      f.input :width
      f.input :height
      f.input :unit

      if f.object.image
        f.input :cover, as: :file, hint: image_tag(f.object.image.url, width: '100px', height: '100px')
      else
        f.input :cover
      end

      f.input :super_category, as: :searchable_select
      # f.input :sub_categories
    end
    f.actions
  end

end
