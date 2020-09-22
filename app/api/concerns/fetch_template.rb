require 'api_exception'

module FetchTemplate
  extend ActiveSupport::Concern

  included do
    helpers do
      def get_template(sub_c)
          return {
            id: sub_c.id, 
            name: sub_c.title, 
            name_ar: sub_c.title_ar,
            images: sub_c.designers.where('approved', true).includes(:design).all.filter { |designer, key|
              designer.approved
            }.map { |designer| 
              {
                id: designer.design.id,
                title: designer.design.title,
                url: designer.design.image.thumb.url,
                json: designer.design.styles,
                height: designer.design.height,
                width: designer.design.width,
                is_trashed: designer.design.is_trashed
              } 
            }
          }
      end
    end
  end
end
