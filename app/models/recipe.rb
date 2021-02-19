class Recipe < ApplicationRecord
  belongs_to :recipe_type
  belongs_to :cuisine
  belongs_to :user

  has_many :recipe_sets, dependent: :nullify
  has_many :recipe_lists, through: :recipe_sets

  has_one_attached :photo

  validates :title, :difficulty, :recipe_type,
            :cuisine, :cook_time,
            :ingredients, :cook_method,
            presence: true

  def cook_time_min
    "#{cook_time} minutos"
  end
end
