module SortReservedIconAdmin
    extend ActiveSupport::Concern
  
    included do
      rails_admin do
        list do
            exclude_fields :id, :created_at, :updated_at                        
        end
        edit do
            field :title do 
                read_only true
            end
            field :position, :enum do
                enum do
                    SortReservedIcon.all.collect{|icon| icon.position}
                end
            end
        end
      end
    end
  end