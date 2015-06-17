class BooksController < ApplicationController
  before_action :require_user

  def index
    @countries = Country.all
  end

  def show
    @book = Book.find(params[:id])
    @reviews = @book.reviews
    @review = Review.new
  end
  
  def search
    @results = Book.search(params[:search_term])
    if @results.empty?
      flash[:error] = "Sorry, your search yielded no results!"
      redirect_to home_url
    end
  end
end