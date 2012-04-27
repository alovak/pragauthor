# encoding: utf-8

Given /^I have book sales$/ do
  Timecop.travel(Chronic.parse("31 Dec 2011"))

  author = sign_in

  @book = Factory(:book, :user => author)

  bn = Vendor.find_by_name("Barnes&Noble")
  smash = Vendor.find_by_name("Smashwords")

  { "01 Jan 2010" => { :units => 1, :vendor => bn,    :amount => 1000,  :currency => 'USD' },
    "05 Feb 2010" => { :units => 1, :vendor => bn,    :amount => 1000,  :currency => 'USD' }, 
    "20 Feb 2010" => { :units => 5, :vendor => smash, :amount => 5000,  :currency => 'EUR' }, 
    "25 Feb 2010" => { :units => 2, :vendor => bn,    :amount => 5000,  :currency => 'EUR' }, 
    "10 Jun 2010" => { :units => 1, :vendor => bn,    :amount => 1000,  :currency => 'USD'  }, 

    # last year sales
    "20 Dec 2010" => { :units => 5, :vendor => smash, :amount => 5000,  :currency => 'USD' }, 
    "02 Jan 2011" => { :units => 1, :vendor => smash, :amount => 1000,  :currency => 'USD' }, 
    "07 Mar 2011" => { :units => 1, :vendor => bn,    :amount => 1000,  :currency => 'USD' }, 
    "21 Sep 2011" => { :units => 1, :vendor => bn,    :amount => 1000,  :currency => 'USD' }, 
    "30 Nov 2011" => { :units => 1, :vendor => smash, :amount => 1000,  :currency => 'USD' }, 
  }.each do |date, data|
    @book.sales << Factory(:sale, data.update(:book => @book, :date_of_sale => Chronic.parse(date)))
  end
end

When /^I navigated to the book page$/ do
  visit book_path(@book)
end

Then /^I should see royalties for the last year with units grouped by month$/ do
  within("table.royalties") do
    ['Dec 2010', 'Jan 2011', 'Feb 2011', 'Mar 2011', 'Apr 2011',
     'May 2011', 'Jun 2011', 'Jul 2011', 'Aug 2011', 'Sep 2011',
     'Oct 2011', 'Nov 2011', 'Dec 2011'].each do |date|
      page.should have_css('td', :text => date)
    end

    page.should have_css('td', :text => "$50.00")
    page.should have_css('td', :text => "$10.00", :count => 4)
  end

  page.should have_css("#royalties_chart")
  page.should have_css("#vendor_share_chart")
end

When /^I set a period and currency$/ do
  select "Jan 2010", :from => "date_range_from"
  select "Aug 2010", :from => "date_range_to"
  click_button "Set Period"
  click_link "EUR"
end

Then /^I should see royalties for the period and currency$/ do
  within("table.royalties") do
    ['Jan 2010', 'Feb 2010', 'Jun 2010'].each do |date|
      page.should have_css('td', :text => date)
    end

    page.should have_css('td', :text => "100.00 €")
  end

  page.should have_css("#royalties_chart")
  page.should have_css("#vendor_share_chart")
end

