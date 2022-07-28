class Comment < ApplicationRecord
  
  validates :description, presence: true, length: { minimum: 4, maximum: 140 }
  belongs_to :user
  belongs_to :article
  validates :user_id, :article_id, presence: true
  
  default_scope -> {order(updated_at: :desc)}
end