ActiveAdmin.register Tag do
  searchable_select_options(scope: Tag.all, text_attribute: :name)
  permit_params :name, :name_ar
  config.batch_actions = false
  filter :name
  filter :name_ar

  action_item 'create_tag', only: :show do
    link_to 'CREATE TAG', new_admin_tag_path
  end

  controller do
    def create
      translate = Google::Cloud::Translate::V2.new(project_id: ENV['GOOGLE_PROJECT_ID'], credentials: (JSON.parse ENV['GOOGLE_SERVICE_ACCOUNT_CREDENTIALS']))  
      translation = translate.translate params[:tag][:name], from: "en", to: "ar"
      params[:tag][:name_ar] = translation.text
      super
    end
  end

  index do
    column :id
    column :name
    column :name_ar 
    actions
  end

end
