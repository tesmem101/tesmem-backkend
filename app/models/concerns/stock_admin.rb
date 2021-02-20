module StockAdmin
  extend ActiveSupport::Concern

  included do
    rails_admin do
      list do
        configure :description do
          hide
        end
      end
    end
  end
end