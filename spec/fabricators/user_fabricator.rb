Fabricator(:user) do
  email { Faker::Internet.email }
  password_digest "password"
end