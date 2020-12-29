require 'api_exception'

module FetchIcon
  extend ActiveSupport::Concern

  included do
    helpers do
      def get_icons(sub_c)
          return {
            id: sub_c.id, 
            name: sub_c.title, 
            name_ar: sub_c.title_ar,
            images: serialize_collection(sub_c.stocks, serializer: StockSerializer)
          }
      end
    end
  end
end
