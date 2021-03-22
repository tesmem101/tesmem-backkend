require 'api_exception'

module FetchIcon
  extend ActiveSupport::Concern

  included do
    helpers do
      def get_icons(sub_c, page = 1, per_page = 6)
          return {
            id: sub_c.id, 
            name: sub_c.title, 
            name_ar: sub_c.title_ar,
            images: serialize_collection(Kaminari.paginate_array(sub_c.stocks).page(page).per(per_page), serializer: StockListSerializer)
          }
      end
    end
  end
end
