class Country < ActiveRecord::Base
  has_many :books, -> { order(created_at: :desc) }

  validates_presence_of :name

  def recent_books
    books.first(6)
  end
end
