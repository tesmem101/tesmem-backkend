ActiveAdmin.register SortReservedIcon do
  permit_params :sub_category_id, :title, :position
  sortable tree: false, sorting_attribute: :position
  actions :all, except: [:new, :create, :edit, :update, :show, :destroy]
  config.batch_actions = false
  menu false

  filter :title

  controller do
    def scoped_collection
      SortReservedIcon.sub_categories_which_has_stocks
    end
  end

  index :as => :sortable do
    label :title # item content
  end
  
end
