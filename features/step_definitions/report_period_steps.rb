module SessionHelper
  def sign_in(params = {})

    @author = Factory.create(:confirmed_user, params[:with] || {})

    visit "/users/sign_in"

    fill_in "Email", :with => @author.email
    fill_in "Password", :with => @author.password

    click_button "Sign in"

    page.should have_content "Signed in successfully"

    @author
  end
end

World(SessionHelper)

Given /^I have a sales for long period$/ do
  Timecop.travel(Chronic.parse("31 Dec 2011"))

  author = sign_in

  book = Factory(:book, :user => author)

  bn = Vendor.find_by_name("Barnes&No,bble")
  smash = Vendor.find_by_name("Smashwords")

  { "01 Jan 2010" => { :units => 1, :vendor => bn,    :amount => 1000,  :currency => 'USD' },
    "05 Feb 2010" => { :units => 1, :vendor => bn,    :amount => 1000,  :currency => 'USD' }, 
    "10 Jun 2010" => { :units => 1, :vendor => bn,    :amount => 1000,  :currency => 'USD'  }, 
    "20 Dec 2010" => { :units => 1, :vendor => smash, :amount => 1000,  :currency => 'USD' }, 
    "02 Jan 2011" => { :units => 1, :vendor => smash, :amount => 1000,  :currency => 'USD' }, 
    "07 Mar 2011" => { :units => 1, :vendor => bn,    :amount => 1000,  :currency => 'USD' }, 
    "21 Sep 2011" => { :units => 1, :vendor => bn,    :amount => 1000,  :currency => 'USD' }, 
    "30 Nov 2011" => { :units => 1, :vendor => smash, :amount => 1000,  :currency => 'USD' }, 
  }.each do |date, data|
    book.sales << Factory(:sale, data.update(:book => book, :date_of_sale => Chronic.parse(date)))
  end

  author.should have(8).sales
end

When /^I navigated to dashboard$/ do
  visit "/home"
end

Then /^I should see total sales$/ do
  find("select#date_range_from").should have_content("December 2011")
  find("select#date_range_to").should have_content("December 2010")
  find(".royalties .number").should have_content("$80.00")
  find(".units .number").should have_content("8")
end

Then /^I should see monthly sales for the last year$/ do
  find("select#date_range_from").should have_content("December 2011")
  find("select#date_range_to").should have_content("December 2010")

  within(".period_totals") do
    find(".royalties .number").should have_content("$50.00")
    find(".units .number").should have_content("5")
  end
end

When /^I set period for the last 5 months$/ do
  select "December 2011", :from => "date_range_to"
  select "August 2011", :from => "date_range_from"
  click_button "Show"
end

Then /^I should see monthly sales for the last 5 months$/ do
  find("select#date_range_from").should have_content("August 2011")
  find("select#date_range_to").should have_content("December 2011")

  within(".period_totals") do
    find(".royalties .number").should have_content("$20.00")
    find(".units .number").should have_content("2")
  end
end
