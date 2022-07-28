class Article < ApplicationRecord
  before_save :name_format, :description_format

  belongs_to :user

  has_many :article_categories
  has_many :categories, through: :article_categories
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  has_many_attached :image

  default_scope -> { order(updated_at: :desc) }

  validates :name, :description, :user_id, presence: true
  validates :description, length: { minimum: 5, maximum: 500 }
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: "must be a valid image format" },
                    size: { less_than: 5.megabytes,
                            message: "should be less than 5MB" }

  def thumbs_up_total
    self.likes.where(like: true).size
  end

  def thumbs_down_total
    self.likes.where(like: false).size
  end

  def is_bookmarked user
    Bookmark.find_by(user_id: user.id, article_id: id)
  end


  def display_image(image)
    image.variant(combine_options: {
      auto_orient: true,
      gravity: "center",
      resize: "250x250^",
      crop: "250x250+0+0",
    })
  end

  private

  def name_format
    self.name = name.split.map(&:capitalize) * " "
  end

  def description_format
    self.description = description.capitalize
  end
end
