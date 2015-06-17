require 'spec_helper'

describe Country do
  it { should have_many(:books) }
  it { should validate_presence_of(:name) }
  
  let(:tanzania) { Fabricate(:country, name: "Tanzania") }
  let(:italy) { Fabricate(:country, name: "Italy") }

  describe "#recent_books" do

    it "returns an empty array if the country does not have any books" do
      expect(italy.recent_books).to eq([])
    end

    it "returns an array of books in reverse chronological order" do
      tuscan_sun = Fabricate(:book, title: "Under the Tuscan Sun", description: "Italy", country: italy, created_at: 1.day.ago)
      fortune = Fabricate(:book, title: "City of Fortune", description: "Italy", country: italy)  
      expect(italy.recent_books).to eq([fortune, tuscan_sun])
    end

    it "returns an array of all books if there are fewer than six total" do
      tuscan_sun = Fabricate(:book, title: "Under the Tuscan Sun", description: "Italy", country: italy)
      fortune = Fabricate(:book, title: "City of Fortune", description: "Italy", country: italy)
      expect(italy.recent_books.count).to eq(2)
    end

    it "returns the most recent 6 books" do
      6.times { Fabricate(:book, title: "foo", description: "bar", country: italy) }
      new_book = Fabricate(:book, title: "new", description: "book", country: italy, created_at: 1.day.ago)
      expect(italy.recent_books).not_to include(new_book)
    end

    it "returns 6 books if there are more than 6 books" do
      7.times { Fabricate(:book, title: "foo", description: "bar", country: italy) }
      expect(italy.recent_books.count).to eq(6)
    end
  end
end
