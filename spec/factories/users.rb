Factory.define :user do |u|
  u.email        { Faker::Internet.email }
  u.name        { Faker::Name.name }
  u.password     'password123'
end

Factory.define :confirmed_user, :parent => :user do |u|
  u.after_create  { |user| user.confirm! }
  u.after_build  { |user| user.confirm! }
  u.after_stub   { |user| user.confirm! }
end

