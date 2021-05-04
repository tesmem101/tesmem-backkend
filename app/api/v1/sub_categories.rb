module V1
  class SubCategories < Grape::API
    include AuthenticateRequest
    include V1Base
    include FetchSubCategories
    version 'v1', using: :path

    resource :subcategories do
      
      desc 'Add SubCategory',
           { consumes: ['application/x-www-form-urlencoded'],
            http_codes: [
             { code: 200, message: 'success' },
             { code: RESPONSE_CODE[:forbidden], message: I18n.t('errors.forbidden') },
             { code: RESPONSE_CODE[:unprocessable_entity], message: 'Validation error messages' },
             { code: RESPONSE_CODE[:not_found], message: I18n.t('errors.not_found') },
           ] }
      params do
        requires :title, type: String, desc: 'Title'
        optional :title_ar, type: String, desc: 'Title ar'
        optional :description, type: String, desc: 'Description'
        requires :category_id, type: Integer, desc: 'Category Id'
      end
      post '/create' do
        subcategory = SubCategory.new(params)
        if subcategory.save!
          serialization = SubCategorySerializer.new(subcategory)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:forbidden], subcategory.errors.full_messages.join(', '))
        end
      end
      
      desc 'Get all Subcategories',
        { consumes: ['application/x-www-form-urlencoded'],
          http_codes: [{ code: 200, message: 'success' }] }
      get '/' do
        subcategory = all_sub_categories()
        serialization = serialize_collection(subcategory, serializer: SubCategorySerializer)
        render_success(serialization.as_json)
      end
      
      desc 'Get SubCategory',
           { consumes: ['application/x-www-form-urlencoded'],
             http_codes: [{ code: 200, message: 'success' }] }
      get '/:id' do
        subcategory = SubCategory.find(params[:id])
        if subcategory.present?
          serialization = SubCategorySerializer.new(subcategory)
          render_success(serialization.as_json)
        end
      end
      
      desc 'Update SubCategory',
           { consumes: ['application/x-www-form-urlencoded'],
            http_codes: [
             { code: 200, message: 'success' },
             { code: RESPONSE_CODE[:forbidden], message: I18n.t('errors.forbidden') },
             { code: RESPONSE_CODE[:unprocessable_entity], message: 'Validation error messages' },
             { code: RESPONSE_CODE[:not_found], message: I18n.t('errors.not_found') },
           ] }
      params do
        requires :title, type: String, desc: 'Title'
        optional :description, type: String, desc: 'Description'
      end
      put '/:id' do
        subcategory = SubCategory.find(params[:id])
        if subcategory.update(params)
          serialization = SubCategorySerializer.new(subcategory)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:unprocessable_entity], subcategory.errors.full_messages.join(', '))
        end
      end
     
      desc 'Delete SubCategory',
           { consumes: ['application/x-www-form-urlencoded'],
             http_codes: [{ code: 200, message: 'success' }] }

      delete '/:id' do
        SubCategory.find(params[:id]).destroy
        render_success('SubCategory Deleted Successfully'.as_json)
      end

      desc 'Assign position to SubCategorie for sorting',
      { consumes: ['application/x-www-form-urlencoded'],
        http_codes: [{ code: 200, message: 'success' }] }

      post '/assign_position' do
        SortSubCategory.destroy_all # First destroy all the previous data
        position = 0
        Category.all.each do |category| # Now assign positions
          category.sub_categories.each_with_index do |sub_category, index|
            SortSubCategory.create(category_id: category.id, sub_category_id: sub_category.id, sub_category_title: sub_category.title, position: index)
          end
        end
        render_success('Positions are assigned to SubCategories'.as_json)
      end

    end
  end
end
