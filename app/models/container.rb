class Container < ApplicationRecord
    enum options: ['design', 'image']
    belongs_to :folder
end
