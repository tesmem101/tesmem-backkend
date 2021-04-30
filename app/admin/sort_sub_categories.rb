ActiveAdmin.register SortSubCategory do
  permit_params :category_id, :sub_category_id, :sub_category_title, :position
  sortable tree: false, sorting_attribute: :position
  actions :all, except: [:new, :create, :edit, :update, :show, :destroy]
  config.batch_actions = false

  # filter :sub_category_title  
  filter :category, collection: -> {
    Category.where.not(super_category_id: nil).or(Category.where(title: TITLES[:icon])).all.map {|cat| [cat.title, cat.id]}
  }, as: :searchable_select

  before_action :only => [:index] do
    if params['commit'].blank? && params['q'].blank? && params[:scope].blank?
       params['q'] = {:category_id_eq => "13"}
    end
  end


  controller do
    def scoped_collection
      if params[:q].present? && params[:q][:category_id_eq].present? && params[:q][:category_id_eq].eql?('13')
        SortSubCategory.where(
          sub_category_id: Category.find_by(title: TITLES[:icon])
          .sub_categories
          .joins(:stocks)
          .select("distinct sub_categories.id")
      )
      elsif params[:q].present? && params[:q][:category_id_eq].present?
        SortSubCategory.where(
          sub_category_id: Category.find_by(id: params[:q][:category_id_eq])
          .sub_categories
          .joins(:designers)
          .select("distinct sub_categories.id")
        )
      end

    end
  end

  index :as => :sortable do
    label :sub_category_title # item content
  end
end
