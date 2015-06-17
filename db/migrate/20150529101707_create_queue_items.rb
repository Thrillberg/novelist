class CreateQueueItems < ActiveRecord::Migration
  def change
    create_table :queue_items do |t|
      t.integer :book_id
      t.integer :user_id
      t.integer :position

      t.timestamps null: false
    end
  end
end
