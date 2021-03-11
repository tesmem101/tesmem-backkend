ActiveAdmin.register User do
  permit_params :first_name, :last_name, :email, :role, :profile

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
      f.input :role

      if f.object.image.url
        f.input :profile, as: :file, hint: image_tag(f.object.image.url, width: '100px', height: '100px')
      else
        f.input :profile
      end

    end
    f.actions
  end

end
