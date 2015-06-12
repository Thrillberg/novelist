require 'spec_helper'

describe QueueItem do
  it { should delegate_method(:country).to(:book) }
  it { should delegate_method(:title).to(:book).with_prefix }
  it { should validate_numericality_of(:position).only_integer }

  describe "#book_title" do
    it "returns the title of the associated book" do
      book = Fabricate(:book, title: "Under the Tuscan Sun")
      queue_item = Fabricate(:queue_item, book: book)
      expect(queue_item.book_title).to eq("Under the Tuscan Sun")
    end
  end

  describe "#rating" do
    it "returns the rating from the review when the review is present" do
      book = Fabricate(:book)
      user = Fabricate(:user)
      review = Fabricate(:review, user: user, book: book, rating: 4)
      queue_item = Fabricate(:queue_item, user: user, book: book)
      expect(queue_item.rating).to eq(4)
    end

    it "returns nil when the review is not present" do
      book = Fabricate(:book)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, book: book)
      expect(queue_item.rating).to eq(nil)
    end
  end

  describe "#ratings=" do
    it "changes the rating of the review is the review is present" do
      book = Fabricate(:book)
      user = Fabricate(:user)
      review = Fabricate(:review, user: user, book: book, rating: 2)
      queue_item = Fabricate(:queue_item, user: user, book: book)
      queue_item.rating = 4
      expect(Review.first.rating).to eq(4)
    end

    it "clears the rating of the review if the review is  present" do
      book = Fabricate(:book)
      user = Fabricate(:user)
      review = Fabricate(:review, user: user, book: book, rating: 2)
      queue_item = Fabricate(:queue_item, user: user, book: book)
      queue_item.rating = nil
      expect(Review.first.rating).to be_nil
    end

    it "creates a review with the rating if the review is not present" do
      book = Fabricate(:book)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, book: book)
      queue_item.rating = 3
      expect(Review.first.rating).to eq(3)
    end
  end

  describe "#country_name" do
    it "returns the country's name of the book" do
      country = Fabricate(:country, name: "Austria")
      book = Fabricate(:book, country: country)
      queue_item = Fabricate(:queue_item, book: book)
      expect(queue_item.country_name).to eq("Austria")
    end
  end

  describe "#country" do
    it "returns the country of the book" do
      country = Fabricate(:country, name: "Austria")
      book = Fabricate(:book, country: country)
      queue_item = Fabricate(:queue_item, book: book)
      expect(queue_item.country).to eq(country)
    end
  end

end
