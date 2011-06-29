Factory.sequence :email do |n|
  "girl#{n}@example.com"
end

Factory.sequence :name do |n|
  "John Doe #{n}"
end

Factory.define :user do |u|
  u.email        { Factory.next :email }
  u.name        { Factory.next :name }
  u.password     'password123'
end

Factory.define :confirmed_user, :parent => :user do |u|
  u.after_create  { |user| user.confirm! }
  u.after_build  { |user| user.confirm! }
  u.after_stub   { |user| user.confirm! }
end

