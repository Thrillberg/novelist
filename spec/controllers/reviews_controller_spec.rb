require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    let(:book) { Fabricate(:book) }
    context "with authenticated users" do
      let(:current_user) { Fabricate(:user) }
      before { session[:user_id] = current_user.id }

      context "with valid inputs" do
        before do
          post :create, review: Fabricate.attributes_for(:review), book_id: book.id
        end
        it "redirects to the book show page" do
          expect(response).to redirect_to book
        end

        it "creates a review" do
          expect(Review.count).to eq(1)
        end

        it "creates a review associated with the book" do
          expect(Review.first.book).to eq(book)
        end

        it "creates a review associated with thet signed in user" do
          expect(Review.first.user).to eq(current_user)
        end
      end

      context "with invalid inputs" do
        it "does not create a review" do
          set_review
          expect(Review.count).to eq(0)
        end

        it "renders the books/show template" do
          set_review
          expect(response).to render_template "books/show"
        end

        it "sets @book" do
          set_review
          expect(assigns(:book)).to eq(book)
        end

        it "sets @ reviews" do
          review = Fabricate(:review, book: book)
          set_review
          expect(assigns(:reviews)).to match_array([review])
        end
      end
    end
    context "with unauthenticated users" do
      it "redirects to the sign in path" do
        post :create, review: Fabricate.attributes_for(:review), book_id: book.id
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end