ActiveAdmin.register Container do
  permit_params :folder_id, :instance_id, :instance_type

  filter :folder
  filter :instance_type

  controller do
    include ActionView::Helpers::TextHelper
    def create
      if params[:container][:folder_id].present? && params[:container][:instance_type].present? && params[:container][:instance_id].present?
        if params[:container][:instance_type] == 'Design'
          instance = Design.find(params[:container][:instance_id])
        elsif params[:container][:instance_type] == 'Upload'
          instance = Upload.find(params[:container][:instance_id])
        end
        @container = Container.create(instance: instance, folder_id: params[:container][:folder_id])
        if @container.save
          flash[:notice] = "Container Created!"
          redirect_to admin_container_path(@container)
        else
          flash[:error] = ["#{pluralize(@container.errors.count, "error")} prohibited this upload from being updated!"]
          @container.errors.full_messages.each do |msg|
            flash[:error] << msg
          end
          redirect_to new_admin_container_path
        end
      else
        flash[:error] = "All Fields are required!"
        redirect_to new_admin_container_path
      end

    end

    private

    def container_params
      params.require(:container).permit(:folder_id, :instance_id, :instance_type)
    end

  end

  index do
    column :id
    column :folder
    column :instance
    column :instance_type
    actions
  end

  form do |f|
    f.inputs do
      f.input :folder      
      f.input :instance_type, as: :select, collection: ["Upload", "Design"], :input_html => { :onchange => "onInstanceChange(this.value)"}
      
      
      if f.object.new_record? 
        f.input :instance_id, label: 'Instance name', as: :searchable_select, collection: [], required: true
      else
        if f.object.instance_type.eql?('Design')
          f.input :instance_id, label: 'Instance name', as: :searchable_select, collection: Design.all.map{|design| design.title ? [design.title, design.id] : nil}.compact
        elsif f.object.instance_type.eql?('Upload')
          f.input :instance_id, label: 'Instance name', as: :searchable_select, collection: Upload.all.map{|upload| upload.title ? [upload.title, upload.id] : nil}.compact
        end
      end
    end
    actions
  end




end
