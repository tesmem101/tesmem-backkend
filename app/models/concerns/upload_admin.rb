module UploadAdmin
  extend ActiveSupport::Concern

  included do
    rails_admin do
      list do
        field :id
        field :title
        field :image do
          pretty_value do
            bindings[:view].tag(:img, { :src => bindings[:object].image.url(:thumb), width: 80, height: 80}) 
          end
        end
        field :user
      end
    end
  end
end