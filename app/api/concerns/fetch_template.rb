require 'api_exception'

module FetchTemplate
  extend ActiveSupport::Concern

  included do
    helpers do
      def get_template(sub_c)
          return {
            id: sub_c.id, 
            name: sub_c.title, 
            images: serialize_collection(sub_c.stocks, serializer: StockSerializer)
          }
      end
    end
  end
end
