require 'spec_helper'

describe Review do
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:rating) }
  it { should validate_uniqueness_of(:user_id).
        with_message("has already submitted a review for this book.") }

end