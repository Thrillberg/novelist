class Book < ActiveRecord::Base
  has_many :reviews, -> { order(created_at: :desc) }
  belongs_to :country

  validates_presence_of :title, :description, :country

  def self.search(search_term)
    return [] if search_term.blank?
    where(["title LIKE ? OR country LIKE ?", "%#{search_term}%", "%#{search_term}%"]).order(created_at: :desc)
  end

end