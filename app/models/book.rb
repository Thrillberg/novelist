class Book < ActiveRecord::Base
  has_many :reviews, -> { order(created_at: :desc) }
  belongs_to :country

  validates_presence_of :title, :description, :country

  def self.search(search_term)
    return [] if search_term.blank?
    searched_country_id = Country.find_by(name: search_term).try(:id)

    where(["title LIKE ? OR country_id LIKE ?", "%#{search_term}%", "%#{searched_country_id}%"]).order(created_at: :desc)
  end


end