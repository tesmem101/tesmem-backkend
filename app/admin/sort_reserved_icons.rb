ActiveAdmin.register SortReservedIcon do
  permit_params :sub_category_id, :title, :position
  sortable tree: false, sorting_attribute: :position
  actions :all, except: [:new, :create, :edit, :update, :show, :destroy]
  config.batch_actions = false

  filter :title

  index :as => :sortable do
    label :title # item content
  end
  
end
