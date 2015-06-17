class User < ActiveRecord::Base
  attr_accessor :reviews

  validates_presence_of :email, :password
  validates_uniqueness_of :email

  has_secure_password

  has_many :queue_items, -> { order(:position) }

  def normalize_queue_item_positions
    self.queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index+1)
    end
  end

  def queued_book?(book)
    queue_items.map(&:book).include?(book)
  end
end
