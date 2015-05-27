class AddCountryIdToBooks < ActiveRecord::Migration
  def change
    add_column :books, :country_id, :integer
  end
end
