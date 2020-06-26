module V1
  class Templates < Grape::API
    include AuthenticateRequest
    include V1Base
    version "v1", using: :path

    resource :templates do

      desc 'Query String search by Category Id and title',
           { consumes: ['application/x-www-form-urlencoded'],
             http_codes: [{ code: 200, message: 'success' }] }
      get '/' do
        cat_id = params['category_id']
        search = params['search'].present? ? params['search'].downcase : nil
        cat = Category.find(cat_id).sub_categories.where("lower(title) LIKE ?", "%#{search}%").includes(:stocks).all.map { |sub_c| {id: sub_c.id, name: sub_c.title, images: sub_c.stocks.map { |stock| {id: stock.id, title: stock.title, description: stock.description, url: stock.url, stockType: stock.stocktype, height: stock.height, size: stock.size, json: stock.json} }}}
        render_success(cat.as_json)
      end

    end
  end
end
