class Review < ActiveRecord::Base
  belongs_to :book
  belongs_to :user

  validates_presence_of :body, :rating
end
