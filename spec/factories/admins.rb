Factory.define :admin do |admin|
  admin.email        { Faker::Internet.email }
  admin.password     'password123'
end
