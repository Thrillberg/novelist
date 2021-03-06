def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def set_review(review = nil)
  post :create, review: { rating: 4 }, book_id: book.id
end

def sign_in(user = nil)
  user ||= Fabricate(:user)
  visit sign_in_path
  fill_in "email", with: user.email
  fill_in "password", with: user.password
  click_button "Sign In"
end