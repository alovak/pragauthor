Given /^I have a LeanPub account$/ do
  @account = Account::LeanPub.create(password: 'Aqw123Poi', login: 'YvesHanoulle', user: Factory(:confirmed_user))
end

When /^my LeanPub account was synchronized$/ do
  @account.sync
end

Then /^I should have imported books for my LeanPub account with sales$/ do
  @account.books.count.should == 9
  Sale.sum(:amount).should == 70305
  Sale.count.should == 84 
end


