class ReviewsController < ApplicationController
  before_filter :require_user

  def create
    @book = Book.find(params[:book_id])
    review = @book.reviews.build(review_params.merge!(user: current_user))
    if review.save
      redirect_to @book
    else
      @reviews = @book.reviews.reload
      render 'books/show'
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :body)
  end

end