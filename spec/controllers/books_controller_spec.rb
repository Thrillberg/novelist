require 'spec_helper'

describe BooksController do
  describe "GET show" do
    it "sets the @book for authenticated users"
    it "redirects the user to the sign in page for unauthenticated users"
  end

  describe "POST search" do
    it "sets @results for authenticated users"
    it "redirects to sign in page for unauthenticated users"
  end
end