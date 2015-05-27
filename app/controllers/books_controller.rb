class BooksController < ApplicationController

  def show
    @book = Book.find(params[:id])
    @reviews = @book.reviews
  end
  
  def search
    @results = Book.search(params[:search_term])
  end
end