module V1
  class Icons < Grape::API
    include AuthenticateRequest
    include V1Base
    include FetchIcon
    require 'will_paginate/array'
    version "v1", using: :path

    resource :icons do

      desc "Add Sub Category to Icon Category",
        { consumes: ["application/x-www-form-urlencoded"],
         http_codes: [
          { code: 200, message: "success" },
          { code: RESPONSE_CODE[:forbidden], message: I18n.t("errors.forbidden") },
          { code: RESPONSE_CODE[:unprocessable_entity], message: "Validation error messages" },
          { code: RESPONSE_CODE[:not_found], message: I18n.t("errors.not_found") },
        ] }
      params do
        requires :title, type: String, desc: 'Title'
        optional :description, type: String, desc: 'Description'
      end
      post "subcategories/create" do
        category = Category.where(title: TITLES[:icon]).first_or_create
        params['category_id'] = category.id
        subcategory = SubCategory.new(params)
        if subcategory.save!
          serialization = SubCategorySerializer.new(subcategory)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:forbidden], subcategory.errors.full_messages.join(', '))
        end
      end
      desc "Add icons to stocks",
        { consumes: ["application/x-www-form-urlencoded"],
         http_codes: [
          { code: 200, message: "success" },
          { code: RESPONSE_CODE[:forbidden], message: I18n.t("errors.forbidden") },
          { code: RESPONSE_CODE[:unprocessable_entity], message: "Validation error messages" },
          { code: RESPONSE_CODE[:not_found], message: I18n.t("errors.not_found") },
        ] }
      params do
        requires :title, type: String, :desc => 'title'
        requires :image, type: File, :desc => 'source'
        requires :sub_category_id, type: Integer, :desc => 'sub category id'
      end
      post :create do
        category = Category.where(title: TITLES[:icon]).first
        params['category_id'] = category.id
        stock = Stock.new(params)
        if stock.save!
          serialization = StockSerializer.new(stock)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:unauthorized], user.errors.full_messages.join(", "))
        end
      end
      desc 'Get sub categories of icons',
           { consumes: ['application/x-www-form-urlencoded'],
             http_codes: [{ code: 200, message: 'success' }] }
      get '/subcategories/all' do
        sub_categories = Category.where(title: TITLES[:icon]).includes(:sub_categories).map(&:sub_categories).flatten
        serialization = serialize_collection(sub_categories, serializer: SubCategorySerializer)
        render_success(serialization.as_json)
      end
      desc 'Query String search by title',
           { consumes: ['application/x-www-form-urlencoded'],
             http_codes: [
               { code: 200, message: 'success' },
               { code: RESPONSE_CODE[:forbidden], message: I18n.t("errors.forbidden") },
               { code: RESPONSE_CODE[:unprocessable_entity], message: "Validation error messages" },
               { code: RESPONSE_CODE[:not_found], message: I18n.t("errors.not_found") }
              ] 
          }
      params do
        requires :page, type: String, :desc => 'Page Number'
        requires :per_page, type: String, :desc => 'Number of elements on each page'
      end
      get '/' do
        if params['locale'].present?
          if params['locale'] != "ar"
            render_error(RESPONSE_CODE[:not_found], I18n.t("errors.locale.not_found"))
          end
        end
        search = params['search'].present? ? params['search'].downcase : nil
        locale = params['locale'].present? ? "_#{params['locale']}" : ""

        if true?(params['with_categories'])
          category = Category.where(title: TITLES[:icon]).take
          searched_animations = []
          sorted_icons_reponse = []

          if category.present?
            searched_animations = category.sub_categories
              .search_keyword(locale, search).includes(:stocks)
              .all.map { |sub_c| get_icons(sub_c, params[:page], params[:per_page]) }
          end
          sorted_icons = SortReservedIcon.order(:position).map(&:title)
          sorted_icons.collect{|icon| searched_animations.collect{|animation| icon == animation[:name] ? sorted_icons_reponse.push(animation) : nil}}
          render_success(sorted_icons_reponse.as_json)

        elsif !true?(params['with_categories']) && params[:sub_category_id].present?
          subcategory = SubCategory.find(params[:sub_category_id])
          if subcategory.present? 
            icons = get_icons(subcategory, params[:page], params[:per_page])
            render_success(icons.as_json)
          end

        else
          icons_stock = Stock.icons_stock
          icons_stock = icons_stock.search_keyword(locale, search, params[:page], params[:per_page]) if search
          icons_stock = serialize_collection(icons_stock, serializer: StockListSerializer)
          render_success(icons_stock)
        end
      end
    end
  end
end
