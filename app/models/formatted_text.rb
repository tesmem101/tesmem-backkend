class FormattedText < ApplicationRecord
  belongs_to :user
  belongs_to :approvedBy, class_name: 'User', foreign_key: :approvedBy_id, optional: true
  belongs_to :unapprovedBy, class_name: 'User', foreign_key: :unapprovedBy_id, optional: true  
  validates_presence_of :user_id, :style
end
