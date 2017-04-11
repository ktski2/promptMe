class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.text :content
      t.references :user, foreign_key: true
      t.references :prompt, foreign_key: true

      t.timestamps
    end
    add_index :posts, [:user_id, :created_at], name: 'user_post_index'
    add_index :posts, [:prompt_id], name: 'prompt_post_index'
  end
end
