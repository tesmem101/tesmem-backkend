ActiveAdmin.register Folder do
  menu  priority: 6
  permit_params :name, :user_id, :parent_id
  config.batch_actions = false

  filter :name
  filter :user, collection: -> {
    User.all.map {|user| [user.email, user.id]}
  }, as: :searchable_select
  filter :parent, label: 'Parent Folder', as: :searchable_select

  index do
    column :id
    column :name
    column :user
    column 'Parent Folder' do |folder|
      folder.parent
    end
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :user
      row 'Parent Folder' do |folder|
        folder.parent
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :user, :as => :select, :collection => User.all.map {|u| [u.email, u.id]}, as: :searchable_select # , :include_blank => false
      f.input :parent, label: 'Parent Folder',  :as => :select, :collection => Folder.all.map {|f| [f.name, f.id]}, as: :searchable_select
    end
    f.actions
  end

end
