module DesignAdmin
  extend ActiveSupport::Concern

  included do
    rails_admin do
      list do
        include_all_fields # all other default fields will be added after, conveniently
        exclude_fields :styles # but you still can remove fields
      end
      show do
        include_all_fields # all other default fields will be added after, conveniently
        exclude_fields :styles # but you still can remove fields
      end
      edit do
        include_all_fields # all other default fields will be added after, conveniently
        exclude_fields :styles # but you still can remove fields
      end
    end
  end
end