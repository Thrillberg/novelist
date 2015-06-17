require 'spec_helper'

describe Book do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe ".search" do

    let(:tanzania) { Fabricate(:country, name: "Tanzania") }
    let(:italy) { Fabricate(:country, name: "Italy") }

    it "returns an empty array if there is no match to title" do
      st_judes = Fabricate(:book, title: "St. Jude's", country: tanzania)
      tuscan_sun = Fabricate(:book, title: "Under the Tuscan Sun", country: italy)
      expect(Book.search("hello")).to eq([])
    end

    it "returns an array of one book for an exact match to title" do
      st_judes = Fabricate(:book, title: "St. Jude's", country: tanzania)
      tuscan_sun = Fabricate(:book, title: "Under the Tuscan Sun", country: italy)
      expect(Book.search("Under the Tuscan Sun")).to eq([tuscan_sun])
    end

    it "returns an array of several books for an exact match to country" do
      st_judes = Fabricate(:book, title: "St. Jude's", description: "Tanzania", country: tanzania)
      tuscan_sun = Fabricate(:book, title: "Under the Tuscan Sun", description: "Italy", country: italy)
      angels_and_demons = Fabricate(:book, title: "Angels and Demons", description: "Italy", country: italy)
      expect(Book.search("Italy")).to eq([angels_and_demons, tuscan_sun])
    end

    it "returns an array of one book for a partial match on title" do
      st_judes = Fabricate(:book, title: "St. Jude's", description: "Tanzania", country: tanzania)
      tuscan_sun = Fabricate(:book, title: "Under the Tuscan Sun", description: "Italy", country: italy)
      expect(Book.search("Tuscan")).to eq([tuscan_sun])
    end

    it "returns an array of all matches ordered by created_at" do
      st_judes = Fabricate(:book, title: "St. Jude's", description: "Tanzania", country: tanzania)
      tuscan_sun = Fabricate(:book, title: "Under the Tuscan Sun", description: "Italy", created_at: 1.day.ago, country: italy)
      angels_and_demons = Fabricate(:book, title: "Angels and Demons", description: "Italy", country: italy)
      expect(Book.search("Italy")).to eq([angels_and_demons, tuscan_sun])
    end

    it "returns an empty array for a search with an empty string" do
      st_judes = Fabricate(:book, title: "St. Jude's", description: "Tanzania", country: tanzania)
      tuscan_sun = Fabricate(:book, title: "Under the Tuscan Sun", description: "Italy", country: italy)
      expect(Book.search("")).to eq([])
    end

    it "returns an array of all appropriate books for a partial match on country" do
      st_judes = Fabricate(:book, title: "St. Jude's", description: "Tanzania", country: tanzania)
      tuscan_sun = Fabricate(:book, title: "Under the Tuscan Sun", description: "Italy", country: italy)
      angels_and_demons = Fabricate(:book, title: "Angels and Demons", description: "Italy", country: italy)
      expect(Book.search("Ita")).to eq([angels_and_demons, tuscan_sun])
    end

    it "returns an array of all appropriate books for a case insensitive match on country" do
      st_judes = Fabricate(:book, title: "St. Jude's", description: "Tanzania", country: tanzania)
      tuscan_sun = Fabricate(:book, title: "Under the Tuscan Sun", description: "Italy", country: italy)
      angels_and_demons = Fabricate(:book, title: "Angels and Demons", description: "Italy", country: italy)
      expect(Book.search("iTAly")).to eq([angels_and_demons, tuscan_sun])
    end
    
  end
end