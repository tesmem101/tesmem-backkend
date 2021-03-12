ActiveAdmin.register FormattedText do


  permit_params :user_id, :style, :approved, :approvedBy_id, :unapprovedBy_id

  index do
    column :user
    column 'Text' do |text|
      text.style["text"]
    end

    column :approved do |text|
      text.approved.eql?(true) ? (check_box_tag 'approved', text.id, {checked: 'cheked', onChange: 'toggleCheckbox(this);'}) : (check_box_tag 'approved', text.id)
    end
    column :approvedBy do |text|
    end

    column :unapprovedBy
    actions
  end
  
end
