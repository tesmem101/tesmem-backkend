ActiveAdmin.register Feedback do
  menu  priority: 11
  actions :all, except: [:new, :edit, :edit, :destroy]
  filter :happy
  filter :created_at

  index do
    column :id
    column 'User Name' do |feedback|
      link_to feedback.user.first_name, admin_user_path(feedback.user)
    end
    column 'User Email' do |feedback|
      link_to feedback.user.email, admin_user_path(feedback.user)
    end
    column :happy
    column :feedback
    actions
  end
  
end