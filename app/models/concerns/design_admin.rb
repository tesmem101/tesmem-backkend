module DesignAdmin
  extend ActiveSupport::Concern

  included do
    rails_admin do
      list do
        configure :styles do
          hide
        end
      end
    end
  end
end