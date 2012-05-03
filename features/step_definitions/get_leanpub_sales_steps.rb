Given /^I have a LeanPub account$/ do
  @account = Account::LeanPub.create(password: 'Aqw123Poi', login: 'YvesHanoulle')
end

When /^my LeanPub account was synchronized$/ do
  @account.synch
end

Then /^I should have imported books for my LeanPub account with sales$/ do
  @account.books.count.should == 9
  Sale.sum(:amount).should == 70305
  Sale.count.should == 84 
end


