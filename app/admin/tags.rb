ActiveAdmin.register Tag do
  permit_params :name, :name_ar
  config.batch_actions = false
  filter :name
  filter :name_ar

  index do
    column :id
    column :name
    column :name_ar 
    actions
  end

end
