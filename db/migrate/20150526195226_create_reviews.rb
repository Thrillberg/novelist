class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :user_id
      t.integer :book_id
      t.text :body
      t.integer :rating

      t.timestamps null: false
    end
  end
end
