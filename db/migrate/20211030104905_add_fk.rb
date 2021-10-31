class AddFk < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :follows, :users, column: :followee_id
    add_foreign_key :follows, :users, column: :follower_id
  end
end
