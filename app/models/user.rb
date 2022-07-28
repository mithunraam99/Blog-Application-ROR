class User < ApplicationRecord
  before_save :downcase_email, :username_format

  validates :username, presence: true, uniqueness: true, length: { maximum: 10 }, uniqueness: { case_sensitive: false }
  VALID_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  validates :password, presence: true, length: { minimum: 5 }, allow_nil: true
  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  # dependent - na all the associated things will be destroyed
  has_many :messages, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_one_attached :image

  has_secure_password

  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: "must be a valid image format" },
                    size: { less_than: 5.megabytes,
                            message: "should be less than 5MB" }

  def display_image
    image.variant(combine_options: {
                    auto_orient: true,
                    gravity: "center",
                    resize: "220x220^",
                    crop: "250x250+0+0",
                  })
  end

  def display_image1
    image.variant(combine_options: {
                    auto_orient: true,
                    gravity: "center",
                    resize: "150x150^",
                    crop: "180x180+0+0",
                  })
    
  end


  def display_image2
    image.variant(combine_options: {
                    auto_orient: true,
                    gravity: "center",
                    resize: "120x120^",
                    crop: "150x150+0+0",
                  })
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def username_format
    self.username = username.split.map(&:capitalize) * " "
  end
end
