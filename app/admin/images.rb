ActiveAdmin.register Image do
  permit_params :name, :description, :image_id, :image_type, :url, :version, :height, :width
  actions :all, except: [:new]
  filter :name
  filter :description
  filter :url
  filter :version
  filter :width
  filter :height

  index do
    column :id
    column :name
    column :description
    column :image_type
    column 'Image' do |image|
      image_tag image.url, style: "max-width: 75px;"
    end
    column :width
    column :height
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :description
      row :image_type
      row 'Image URL' do |image|
        image.url 
      end
      row 'Image' do |image|
        image_tag image.url, style: "max-width: 75px;"
      end

      row :version
      row :width
      row :height
    end
  end

end
