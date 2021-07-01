module V1
  class Designs < Grape::API
    include AuthenticateRequest
    include V1Base
    include AuthenticateUser
    include SaveImage
    version "v1", using: :path


    resource :designs do

      desc "Get Design titles",
      { consumes: ["application/x-www-form-urlencoded"],
        http_codes: [{ code: 200, message: "success" }] }
      
        get :titles do
        design_titles = Design.all.map{|design| design.title ? {title: design.title, id: design.id} : nil}.compact
        render json: {
          titles: design_titles
        }
      end

      desc "Create a design",
        { consumes: ["application/x-www-form-urlencoded"],
         http_codes: [
          { code: 200, message: "success" },
          { code: RESPONSE_CODE[:forbidden], message: I18n.t("errors.forbidden") },
          { code: RESPONSE_CODE[:unprocessable_entity], message: "Validation error messages" },
          { code: RESPONSE_CODE[:not_found], message: I18n.t("errors.not_found") },
        ] }
      params do
        requires :title, type: String, desc: "Name"
        optional :description, type: String, desc: "Pata"
        requires :user_id, type: Integer, desc: "Creator"
        requires :styles, type: JSON, desc: "Styles"
        optional :height, type: String, desc: "Height"
        optional :width, type: String, desc: "Width"
        requires :image, type: String, desc: "Image"
        optional :is_trashed, type: Integer, desc: "Trash"
        optional :cat_id, type: Integer, desc: "Category Id"
        optional :folder_id, type: Integer, desc: "Folder Id"
      end
      post :create do
        authenticate_user
        params[:image] = encode_image(params[:title], params[:image])
        design = Design.new(params)
        if design.save!
          File.delete(params[:image]) if File.exists? params[:image]
          insert_image(design)
          userId = params[:user_id]
          user = User.find(userId)
          if user.role == 'designer' || user.role == 'lead_designer'
            category = Category.where(title: TITLES[:design]).first_or_create
            sub_category = SubCategory.where(title: DESIGNERS[:subCategory]).first_or_create({category_id:category.id})
            Designer.create(design_id: design.id, category_id: category.id, sub_category_id: sub_category.id, url: design.image)
          end
          if params[:folder_id]
            Container.create(instance: design, folder_id: params[:folder_id])
          end
          serialization = DesignSerializer.new(design)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:unauthorized], user.errors.full_messages.join(", "))
        end
      end
      desc "Update a Design",
        { consumes: ["application/x-www-form-urlencoded"],
         http_codes: [
          { code: 200, message: "success" },
          { code: RESPONSE_CODE[:forbidden], message: I18n.t("errors.forbidden") },
          { code: RESPONSE_CODE[:unprocessable_entity], message: "Validation error messages" },
          { code: RESPONSE_CODE[:not_found], message: I18n.t("errors.not_found") },
        ] }
      params do
        optional :title, type: String, desc: "Name"
        optional :description, type: String, desc: "Description"
        optional :user_id, type: Integer, desc: "Creator"
        optional :styles, type: JSON, desc: "Styles"
        optional :height, type: String, desc: "Height"
        optional :width, type: String, desc: "Width"
        optional :image, type: String, desc: "Image"
        optional :is_trashed, type: Integer, desc: "Trash"
        optional :cat_id, type: Integer, desc: "Category Id"
      end
      put "/:id" do
        user = authenticate_user
        if params[:image]
          params[:image] = encode_image(params[:title], params[:image])
        end
        design = Design.find(params[:id])
        if design.update!(params)
          update_image(design) if params[:image]
          File.delete(params[:image]) if params[:image] && File.exists?(params[:image]) 
          # userId = params[:user_id]
          # user = User.find(userId)
          if user.role == 'designer'
            Designer.where(design_id: params[:id]).update(url: design.image)
          end
          serialization = DesignSerializer.new(design)
          render_success(serialization.as_json)
        else
          render_error(RESPONSE_CODE[:unauthorized], user.errors.full_messages.join(", "))
        end
      end
      desc "Delete Design",
           { consumes: ["application/x-www-form-urlencoded"],
             http_codes: [{ code: 200, message: "success" }] }
      delete "/:id" do
        design = Design.find(params[:id]) 
        if design.templates.present? && design.templates.where(approved: true).any?
          render_error(RESPONSE_CODE[:unprocessable_entity], 'Design is selected as template, so you cannot delete this!')
        else
          design.destroy
          render_success("Design Deleted Successfully".as_json)
        end
      end


      desc "Get Designs",
           { consumes: ["application/x-www-form-urlencoded"],
             http_codes: [{ code: 200, message: "success" }] }
      get "/" do
        user = authenticate_user
        folder_ids = user.folders.map(&:id)
        container_designs_ids = Container.where(folder_id: folder_ids, instance_type: 'Design').map(&:instance_id)
        designs = user.designs.where(is_trashed: 0).where.not(id: container_designs_ids)
        serialization = serialize_collection(designs, serializer: DesignSerializer)
        serialization = serialization.collect {|design| design.attributes.except(:styles, :user).merge(user_id: authenticate_user.id)}
        render_success(serialization.as_json)
      end

      desc "Show design",
           { consumes: ["application/x-www-form-urlencoded"],
             http_codes: [{ code: 200, message: "success" }] }
      get "/:id" do
        user = authenticate_user

        if user.role.eql?('lead_designer')
          design = Design.where(id: params[:id], is_trashed: 0)          
        else
          design = user.designs.where(id: params[:id], is_trashed: 0)
        end
        serialization = serialize_collection(design, serializer: DesignSerializer)
        render_success(serialization.as_json)          

      end

      desc "Show design which are in Designers",
           { consumes: ["application/x-www-form-urlencoded"],
             http_codes: [{ code: 200, message: "success" }] }
      get "/designers/:id" do
        design_id = Designer.joins("inner join designs on designers.design_id = designs.id").where(design_id: params[:id]).select("designs.id")
        design = Design.where(id: design_id).collect{ |design| make_design_object(design, true) }
        render_success(design.as_json)
      end

      desc "Design Used By",
           { consumes: ["application/x-www-form-urlencoded"],
             http_codes: [{ code: 200, message: "success" }] }
      get "/:id/used_by" do
        user = authenticate_user
        design = Design.find(params[:id])
        used_design_saved = user.used_designs.create(user_id: design.user.id, design_id: params[:id])
        render_success(used_design_saved.as_json)
      end

    end
  end
end
