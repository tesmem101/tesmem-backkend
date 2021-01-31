module SubCategoryAdmin
  extend ActiveSupport::Concern

  included do
    rails_admin do
      edit do
        configure :stocks do
          hide
        end
        configure :designers do
          hide
        end
      end
    end
  end
end