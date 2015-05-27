require 'spec_helper'

describe Country do
  it { should have_many(:books) }
  it { should validate_presence_of(:name) }
  
  describe "#recent_books" do
    it "returns an empty array if the country does not have any books" do
      italy = Country.create(name: "Italy")
      expect(italy.recent_books).to eq([])
    end

    it "returns an array of books in reverse chronological order" do
      italy = Country.create(name: "Italy")
      tuscansun = Book.create(title: "Under the Tuscan Sun", description: "Italy", country: italy, created_at: 1.day.ago)
      fortune = Book.create(title: "City of Fortune", description: "Italy", country: italy)  
      expect(italy.recent_books).to eq([fortune, tuscansun])
    end

    it "returns an array of all books if there are fewer than six total"
    it "returns the most recent 6 books"
    it "returns 6 books if there are more than 6 books"
  end
end
