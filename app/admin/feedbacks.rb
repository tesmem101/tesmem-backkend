ActiveAdmin.register Feedback do
  menu  priority: 11
  actions :all, except: [:new, :edit, :edit, :destroy]
  filter :happy
  filter :created_at

  index do
    column :id
    column :happy
    column :feedback
    actions
  end
  
end