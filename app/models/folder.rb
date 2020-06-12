class Folder < ApplicationRecord
  belongs_to :user

  has_many   :subfolders, class_name: "Folder", foreign_key: "parent_id", dependent: :destroy
  belongs_to :parent,     class_name: "Folder", optional: true
  
end
