class RemoveCountryFromBooks < ActiveRecord::Migration
  def change
    remove_column :books, :country, :string
  end
end
