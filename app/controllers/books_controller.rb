class BooksController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def show
    @book = Book.find(params[:id])
    @reviews = @book.reviews
  end
  
  def search
    @results = Book.search(params[:search_term])
  end
end