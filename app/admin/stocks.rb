ActiveAdmin.register Stock do
  permit_params :title, :description, :url, :category_id, :sub_category_id, :json, :image, :svg, :stocktype, :specs, :title_ar, :svg_thumb, :stock_tags, :tags, :tag_ids 

  filter :title
  filter :title_ar
  filter :category
  filter :sub_category
  filter :stocktype, as: :select, collection: [['image', 0], ['svg', 1]]
  filter :tags

  controller do
    include ActionView::Helpers::TextHelper
    def create
      @stock = Stock.new(stock_params)
      if @stock.save
        if params[:stock][:tag_ids].present?
          tag_ids = params[:stock][:tag_ids].reject { |id| (id == "" || id == " ")}
          tag_ids.each do |tag_id|
            StockTag.create(stock_id: @stock.id, tag_id: tag_id )
          end
        end
        flash[:notice] = "Stock Created!"
        redirect_to admin_stock_path(@stock)
      else
        flash[:error] = ["#{pluralize(@stock.errors.count, "error")} prohibited this stock from being created!"]
        @stock.errors.full_messages.each do |msg|
          flash[:error] << msg
        end
        redirect_to new_admin_stock_path
      end
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
        redirect_to admin_stock_path(@stock)
      else
        flash[:error] = ["#{pluralize(@stock.errors.count, "error")} prohibited this stock from being updated!"]
        @stock.errors.full_messages.each do |msg|
          flash[:error] << msg
        end
        redirect_to edit_admin_stock_path
      end
    end

    private

    def stock_params
      params.require(:stock).permit(:title, :description, :url, :category_id, :sub_category_id, :json, :image, :svg, :stocktype, :specs, :title_ar, :svg_thumb, :stock_tags, :tags, :tag_ids)
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
    column :svg_thumb do |stock|
      stock.svg_thumb.present? ? image_tag(stock.svg_thumb.url, style: "max-width: 75px;") : nil
    end
    column :tags
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
      row :stocktype
      row :image do |stock|
        stock.image.present? ? image_tag(stock.image.url, style: "max-width: 75px;") : nil
      end
      row :svg do |stock|
        stock.svg.present? ? image_tag(stock.svg.url, style: "max-width: 75px;") : nil
      end
      row :svg_thumb do |stock|
        stock.svg_thumb.present? ? image_tag(stock.svg_thumb.url, style: "max-width: 75px;") : nil
      end
      row :tags
    end
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :title_ar
      f.input :category
      f.input :sub_category

      if f.object.image.url
        f.input :image, as: :file, hint: image_tag(f.object.image.url, width: '100px', height: '100px')
      else
        f.input :image
      end

      if f.object.svg.url
        f.input :svg, as: :file, hint: image_tag(f.object.svg.url, width: '100px', height: '100px')
      else
        f.input :svg
      end

      if f.object.svg_thumb.url
        f.input :svg_thumb, as: :file, hint: image_tag(f.object.svg_thumb.url, width: '100px', height: '100px')
      else
        f.input :svg_thumb
      end
      f.input :stocktype
      f.input :tags
    end
    actions
  end

end