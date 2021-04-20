ActiveAdmin.register Tag do
  searchable_select_options(scope: Tag.all, text_attribute: :name)
  permit_params :name, :name_ar
  config.batch_actions = false
  filter :name
  filter :name_ar

  action_item 'create_tag', only: :show do
    link_to 'CREATE TAG', new_admin_tag_path
  end

  index do
    column :id
    column :name
    column :name_ar 
    actions
  end

end
