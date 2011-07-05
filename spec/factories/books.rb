Factory.define :book do |b|
  b.association :user
  b.title { Faker::Lorem.words(2) }
end
