class Container < ApplicationRecord
    belongs_to :folder
    belongs_to :instance, polymorphic: true
end
