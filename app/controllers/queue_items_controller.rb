class QueueItemsController < ApplicationController
  before_filter :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    if params[:book_id].present? && current_user.queue_items.count < 3
      book = Book.find(params[:book_id])
      queue_book(book)
      redirect_to my_queue_path
    elsif params[:country_id].present? && current_user.queue_items.count == 0
      country = Country.find(params[:country_id])
      queue_random_books(country)
      redirect_to my_queue_path
    else
      flash[:alert] = "Your queue is already full."
      redirect_to my_queue_path
    end
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if current_user.queue_items.include?(queue_item)
    current_user.normalize_queue_item_positions
    redirect_to my_queue_path
  end

  def update_queue
    begin
      update_queue_items
      current_user.normalize_queue_item_positions
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "Invalid position numbers."
    end
    redirect_to my_queue_path
  end

  private

  def queue_book(book)
    QueueItem.create(book: book, user: current_user, position: new_queue_item_position) unless current_user_queued_book?(book)
  end

  def queue_random_books(country)
    random_books = country.books.shuffle.take(3)
    random_books.each do |book|
      QueueItem.create(book: book, user: current_user, position: new_queue_item_position)
    end
  end

  def new_queue_item_position
    current_user.queue_items.count + 1
  end

  def current_user_queued_book?(book)
    current_user.queue_items.map(&:book).include?(book)
  end

  def update_queue_items
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |queue_item_data|
        queue_item = QueueItem.find(queue_item_data[:id])
        queue_item.update_attributes!(position: queue_item_data[:position]) if queue_item.user == current_user
      end
    end
  end
end