ActiveAdmin.register Stock, as: "Frame" do
  menu parent: :stocks
  permit_params :title, :description, :url, :category_id, :sub_category_id, :json, :image, :frame, :svg, :stocktype, :specs, :title_ar, :svg_thumb, :stock_tags, :tags, :tag_ids, :is_active, :pro, :price, :clip_path 

  filter :title
  filter :title_ar
  filter :category_title, as: :string , label: 'Category'
  filter :sub_category_title, as: :string , label: 'Sub Category'
  # filter :stocktype, as: :select, collection: [['frame', 0], ['svg', 1]]
  filter :tags_name, as: :string , label: 'Tags'

  action_item 'create_stock', only: :show do
    link_to 'CREATE STOCK', new_admin_stock_path
  end

  controller do
    include ActionView::Helpers::TextHelper

    def scoped_collection
      Stock.where(stocktype: "frame")
    end

    def create
      @stock = Stock.new(stock_params)
      @stock.category_id = Category.find_by(title: TITLES[:stock]).id # TITLES object is in db_constants file
      @stock.stocktype = "frame"
      # if @stock.save
      #   if params[:stock][:tag_ids].present?
      #     tag_ids = params[:stock][:tag_ids].reject { |id| (id == "" || id == " ")}
      #     tag_ids.each do |tag_id|
      #       StockTag.create(stock_id: @stock.id, tag_id: tag_id )
      #     end
      #   end
      #   flash[:notice] = "Stock Created!"
      #   redirect_to admin_frame_path(@stock)
      # else
      #   flash[:error] = ["#{pluralize(@stock.errors.count, "error")} prohibited this stock from being created!"]
      #   @stock.errors.full_messages.each do |msg|
      #     flash[:error] << msg
      #   end
      #   redirect_to new_admin_frame_path
      # end
    end

    def update
      @stock = Stock.find(params[:id])
      if @stock.update(stock_params)
        if params[:stock][:tag_ids].present?
          @stock.tags.destroy_all
          tag_ids = params[:stock][:tag_ids].reject { |id| (id == "" || id == " ")}
          tag_ids.each do |tag_id|
            StockTag.create(stock_id: @stock.id, tag_id: tag_id)
          end
        end
        flash[:notice] = "Stock Updated!"
        redirect_to admin_frame_path(@stock)
      else
        flash[:error] = ["#{pluralize(@stock.errors.count, "error")} prohibited this stock from being updated!"]
        @stock.errors.full_messages.each do |msg|
          flash[:error] << msg
        end
        redirect_to edit_admin_frame_path
      end
    end


    def destroy
      @stock = Stock.find(params[:id])
      if @stock.update(is_active: false)
        flash[:notice] = "Stock Inactive!"
        redirect_to admin_frame_path(@stock)
      else
        flash[:alert] = ["#{pluralize(@stock.errors.count, "error")} prohibited this stock from being inactive!"]
        @stock.errors.full_messages.each do |msg|
          flash[:alert] << msg
        end
        redirect_to admin_frame_path(@stock)
      end
    end

    private

    def stock_params
      params.require(:stock).permit(:title, :description, :url, :category_id, :sub_category_id, :json, :image, :frame, :svg, :stocktype, :specs, :title_ar, :svg_thumb, :stock_tags, :tags, :tag_ids, :is_active, :pro, :price, :clip_path)
    end

  end

  index do
    column :id
    column :title
    column :title_ar
    # column :description do |stock|
    #   stock.description ? stock.description.truncate(50) : stock.description 
    # end
    column :category
    column :sub_category
    column :stocktype
    column :image do |stock|
      stock.image.present? ? image_tag(stock.image.url, style: "max-width: 75px;") : nil
    end
    column :svg do |stock|
      stock.svg.present? ? image_tag(stock.svg.url, style: "max-width: 75px;") : nil
    end
    column 'Thumb' do |stock|
      stock.svg_thumb.present? ? image_tag(stock.svg_thumb.url, style: "max-width: 75px;") : nil
    end
    column :tags
    column :is_active
    # column :pro
    # column :price
    actions
  end

  show do
    attributes_table do
      row :id
      row :title
      row :title_ar
      row :description do |stock|
        stock.description ? stock.description.truncate(50) : stock.description 
      end
      row :category
      row :sub_category
      row :clip_path
      row :stocktype
      row :image do |stock|
        stock.image.present? ? image_tag(stock.image.url, style: "max-width: 75px;") : nil
      end
      row :svg do |stock|
        stock.svg.present? ? image_tag(stock.svg.url, style: "max-width: 75px;") : nil
      end
      row 'Thumb' do |stock|
        stock.svg_thumb.present? ? image_tag(stock.svg_thumb.url, style: "max-width: 75px;") : nil
      end
      row :tags
      row :is_active
      row :pro
      row :price
    end
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :title_ar
      # f.input :category, as: :searchable_select
      div style: 'display: block ruby;' do
        div class: 'stock_sub_category_searchable_select_path' do
          f.input(:sub_category, 
            as: :searchable_select, 
            ajax: {
              params: {
                type: 'frame'
              }
            })          
        end
        div do
          render :partial => 'admin/bootstrap_modals/sub_category'
        end
      end
     
      f.input :clip_path, input_html: { disabled: 'disabled' }
      # f.input :stocktype
      if f.object.image.url
        f.input :image, as: :file, label: 'Frame', hint: image_tag(f.object.image.url, width: '100px', height: '100px')
      else
        f.input :image, label: 'Frame'
      end

      # if f.object.svg.url
      #   f.input :svg, as: :file, hint: image_tag(f.object.svg.url, width: '100px', height: '100px'), input_html: { disabled: 'disabled' }
      # else
      #   f.input :svg, input_html: { disabled: 'disabled' }
      # end

      if f.object.svg_thumb.url
        f.input :svg_thumb, as: :file, label: 'Thumb', hint: image_tag(f.object.svg_thumb.url, width: '100px', height: '100px')
      else
        f.input :svg_thumb, label: 'Thumb'
      end

      div style: 'display: block ruby;' do
        div do
          f.input(:tags, as: :searchable_select, ajax: true)  
        end
        div do
          render :partial => 'admin/bootstrap_modals/tag'
        end
      end
      f.input :is_active
      f.input :pro
      f.input :price
    end
    actions

  end



end
