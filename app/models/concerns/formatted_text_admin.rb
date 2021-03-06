module FormattedTextAdmin
    extend ActiveSupport::Concern
  
    included do
      rails_admin do
        list do
          include_all_fields # all other default fields will be added after, conveniently
          exclude_fields :created_at, :updated_at # but you still can remove fields
        end
        show do
            field :user
            field :approved
            field :approvedBy do
                label 'Approved By'
            end
            field :unapprovedBy do
                label 'Unapproved By'
            end
            field :style
        end
        edit do
            field :user do
                read_only true
            end
          include_all_fields # all other default fields will be added after, conveniently
          exclude_fields :approvedBy, :unapprovedBy # but you still can remove fields
        end
      end
    end
  end