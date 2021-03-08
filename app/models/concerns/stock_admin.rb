module StockAdmin
  extend ActiveSupport::Concern

  included do
    rails_admin do
      list do
        configure :description do
          hide
        end
        configure :json do
          hide
        end
        configure :url do
          hide
        end
        configure :specs do
          hide
        end
        configure :created_at do
          hide
        end
        configure :updated_at do
          hide
        end
      end
      show do
        configure :description do
          hide
        end
        configure :json do
          hide
        end
        configure :url do
          hide
        end
        configure :specs do
          hide
        end
        configure :created_at do
          hide
        end
        configure :updated_at do
          hide
        end
      end
      edit do
        configure :description do
          hide
        end
        configure :json do
          hide
        end
        configure :url do
          hide
        end
        configure :specs do
          hide
        end
        configure :created_at do
          hide
        end
        configure :updated_at do
          hide
        end
      end
    end
  end
end