require 'spec_helper'

describe Book do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:country) }

  describe "search" do
    it "returns an empty array if there is no match to title" do
      tanzania = Country.create(name: "Tanzania")
      italy = Country.create(name: "Italy")
      stjudes = Book.create(title: "St. Jude's", description: "Tanzania", country: tanzania)
      tuscansun = Book.create(title: "Under the Tuscan Sun", description: "Italy", country: italy)
      expect(Book.search("hello")).to eq([])
    end

    it "returns an array of one book for an exact match to title" do
      tanzania = Country.create(name: "Tanzania")
      italy = Country.create(name: "Italy")
      stjudes = Book.create(title: "St. Jude's", description: "Tanzania", country: tanzania)
      tuscansun = Book.create(title: "Under the Tuscan Sun", description: "Italy", country: italy)
      expect(Book.search("Under the Tuscan Sun")).to eq([tuscansun])
    end

    it "returns an array of several books for an exact match to country" do
      tanzania = Country.create(name: "Tanzania")
      italy = Country.create(name: "Italy")
      stjudes = Book.create(title: "St. Jude's", description: "Tanzania", country: tanzania)
      tuscansun = Book.create(title: "Under the Tuscan Sun", description: "Italy", country: italy)
      angelsanddemons = Book.create(title: "Angels and Demons", description: "Italy", country: italy)
      expect(Book.search("Italy")).to eq([angelsanddemons, tuscansun])
    end

    it "returns an array of one book for a partial match on title" do
      tanzania = Country.create(name: "Tanzania")
      italy = Country.create(name: "Italy")
      stjudes = Book.create(title: "St. Jude's", description: "Tanzania")
      tuscansun = Book.create(title: "Under the Tuscan Sun", description: "Italy")
      expect(Book.search("Tuscan")).to eq([tuscansun])
    end

    it "returns an array of all matches ordered by created_at" do
      tanzania = Country.create(name: "Tanzania")
      italy = Country.create(name: "Italy")
      stjudes = Book.create(title: "St. Jude's", description: "Tanzania")
      tuscansun = Book.create(title: "Under the Tuscan Sun", description: "Italy")
      angelsanddemons = Book.create(title: "Angels and Demons", description: "Italy")
      expect(Book.search("Italy")).to eq([angelsanddemons, tuscansun])
    end

    it "returns an empty array for a search with an empty string" do
      tanzania = Country.create(name: "Tanzania")
      italy = Country.create(name: "Italy")
      stjudes = Book.create(title: "St. Jude's", description: "Tanzania")
      tuscansun = Book.create(title: "Under the Tuscan Sun", description: "Italy")
      expect(Book.search("")).to eq([])
    end
    
  end
end