class Message < ApplicationRecord
  
  validates :content, :user_id, presence: true
  belongs_to :user
  
  def self.most_recent
    order(:created_at).last(30)
  end
  
end