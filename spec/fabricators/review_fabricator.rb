Fabricator(:review) do
  book { Fabricate(:book) }
  user { Fabricate(:user) }
  rating { (1..5).to_a.sample }
  body { Faker::Lorem.paragraph(3) }
end