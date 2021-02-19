class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :recipes, dependent: :restrict_with_exception
  has_many :recipe_lists, dependent: :destroy
  has_one_attached :photo

  validates :name, :city, presence: true
  validates :auth_token, uniqueness: true

  before_create :generate_authentication_token!

  def author?(recipe)
    return false unless self == recipe.user

    true
  end

  def info
    "#{email} - #{created_at} - Token: #{Devise.friendly_token}"
  end

  def generate_authentication_token!
    loop do
      self.auth_token = Devise.friendly_token
      break unless User.exists?(auth_token: auth_token)
    end
  end
end
