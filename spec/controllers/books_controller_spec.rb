require 'spec_helper'

describe BooksController do
  describe "GET show" do
    it "sets the @book for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      book = Fabricate(:book)
      get :show, id: book.id
      expect(assigns(:book)).to eq(book)
    end

    it "redirects the user to the sign in page for unauthenticated users" do
      book = Fabricate(:book)
      get :show, id: book.id
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST search" do
    it "sets @results for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      tuscan_sun = Fabricate(:book, title: "Under the Tuscan Sun")
      post :search, search_term: 'uscan'
      expect(assigns(:results)).to eq([tuscan_sun])
    end

    it "redirects to sign in page for unauthenticated users" do
      book = Fabricate(:book)
      post :search, search_term: 'uscan'
      expect(response).to redirect_to sign_in_path
    end
  end
end