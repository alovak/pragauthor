Given /^I have added a LeanPub account$/ do
  @account = Account::LeanPub.create(password: 'QsDrTy123', login: 'PragAuthor', user: Factory(:confirmed_user))
end

Then /^I should have imported books for my LeanPub account with sales$/ do
  @account.books.count.should == 2
  Sale.sum(:amount).should == 91761
  Sale.count.should == 110
end


