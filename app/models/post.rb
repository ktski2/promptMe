class Post < ApplicationRecord
  belongs_to :user
  belongs_to :prompt

  default_scope -> { order(created_at: :desc) }
  
  #validates :user_id, presence: true
  validates :prompt_id, presence: true
  validates :content, presence: true
end
