class BooksController < ApplicationController
  before_action :require_user

  def index
    @countries = Country.all
  end

  def show
    @book = Book.find(params[:id])
    @reviews = @book.reviews
  end
  
  def search
    @results = Book.search(params[:search_term])
    if []
      flash[:error] = "Sorry, your search yielded no results!"
      redirect_to :back
    end
  end
end