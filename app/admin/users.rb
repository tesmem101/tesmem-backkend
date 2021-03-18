ActiveAdmin.register User do
  menu priority: 1 # so it's on the very left
  permit_params :first_name, :last_name, :email, :role, :profile
  config.batch_actions = false
  filter :first_name
  filter :last_name
  filter :email
  filter :role
  filter :created_at

  index do

    if current_user.role.eql?('super_admin')
      selectable_column
    end

    column :id
    column :first_name
    column :last_name
    column :email
    column :role
    column 'Profile Photo' do |user|
      image_tag user.image.url, style: "max-width: 75px;" 
    end
    
    actions
  end

  show do
    attributes_table do
      row :id
      row :first_name
      row :last_name
      row :email
      row :role
      row 'Profile Photo' do |user|
        image_tag user.image.url, style: "max-width: 75px;" 
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :email

      if f.object.new_record?
        f.input :password
      end

      if current_user.role.eql?('super_admin')
        f.input :role, as: :select, collection: [['Super Admin', 'super_admin'], ['Admin', 'admin'], ['Designer', 'designer']], include_blank: false
      elsif current_user.role.eql?('admin')
        f.input :role, as: :select, collection: [['Designer', 'designer']], include_blank: false
      end

      if f.object.image.present?
        f.input :profile, as: :file, hint: image_tag(f.object.image.url, width: '100px', height: '100px')
      else
        f.input :profile
      end

    end
    f.actions
  end

end
