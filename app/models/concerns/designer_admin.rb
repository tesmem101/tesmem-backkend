module DesignerAdmin
    extend ActiveSupport::Concern
  
    included do
      rails_admin do
        label 'Templates'
      end
    end
  end