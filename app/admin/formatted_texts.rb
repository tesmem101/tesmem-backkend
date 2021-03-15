ActiveAdmin.register FormattedText do
  permit_params :user_id, :style, :approved, :approvedBy_id, :unapprovedBy_id
  actions :all, :except => [:new, :destroy, :edit, :update]
  config.batch_actions = false
  # filter :user, collection: -> {
  #   User.all.map {|user| [user.email, user.id]}
  # }

  filter :approved

  index do
    column :id
    column :user
    column 'Text' do |text|
      text.style["text"]
    end

    column :approved do |text|
      text.approved.eql?(true) ? 
      (check_box_tag 'approved', text.id, checked = true, class: "current_user_#{current_user.id}") : 
      (check_box_tag 'approved', text.id, checked = false, class: "current_user_#{current_user.id}")
    end
    # column :approvedBy
    # column :unapprovedBy
    actions
  end

  show do
    attributes_table do 
      row :user
      row 'Text' do |text|
        text.style["text"]
      end
      row :approved
      row :approvedBy
      row :unapprovedBy
    end
  end

  form do |f|
    f.inputs do
      f.input :user, :as => :select, :collection => User.all.map {|u| [u.email, u.id]}, :include_blank => false
    end
    f.actions
  end
  
end
