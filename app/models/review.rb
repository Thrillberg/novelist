class Review < ActiveRecord::Base
  belongs_to :book
  belongs_to :user

  validates_presence_of :body, :rating
  validates_uniqueness_of :user_id, scope: :book_id, message: "has already submitted a review for this book."
end