class Category < ApplicationRecord
  #before_save :name_capitalize
  validates :name, presence: true, length: { minimum: 3, maximum: 25 },uniqueness: true, uniqueness: { case_sensitive: false }
  validates_uniqueness_of :name
  has_many :article_categories
  has_many :articles, through: :article_categories


  private
  def name_capitalize
    self.name = name.capitalize
  end
end
