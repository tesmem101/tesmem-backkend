require 'api_exception'

module FetchTemplate
  extend ActiveSupport::Concern

  included do
    helpers do
      def get_template(sub_c, json = true)
          return {
            id: sub_c.id, 
            name: sub_c.title, 
            name_ar: sub_c.title_ar,
            images: sub_c.designers.approved.includes(:design).all
              .map { |designer|
              {
                id: designer.design.id,
                title: designer.design.title,
                url: designer.design.image.thumb.url,
                json: {},
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
