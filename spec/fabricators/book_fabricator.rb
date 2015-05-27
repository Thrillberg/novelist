Fabricator(:book) do
  title { Faker::Lorem.words(5).join(" ") }
  country { Faker::Lorem.word }
  description { Faker::Lorem.paragraph }
end