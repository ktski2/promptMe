class Prompt < ApplicationRecord
  has_many :posts
  validates :content, presence: true
end
