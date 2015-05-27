class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.text :description
      t.text :small_cover_url
      t.text :large_cover_url

      t.timestamps null: false
    end
  end
end
