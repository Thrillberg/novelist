require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:queue_items).order(:position) }  

  describe "#queued_book?" do
    it "returns true when the user queued the book" do
      user = Fabricate(:user)
      book = Fabricate(:book)
      Fabricate(:queue_item, user: user, book: book)
      expect(user.queued_book?(book)).to be_true
    end
    it "returns false when the user hasn't queued the book" do
      user = Fabricate(:user)
      book = Fabricate(:book)
      expect(user.queued_book?(book)).to be_false
    end
  end
end
