When /^I look statistics for "([^"]*)"$/ do |name|
  @book_name = name

  steps %Q{
    Then I should see "#{name}"
  }
end

Then /^I should see "([^"]*)" units were sold total$/ do |number|
  within(:xpath, %Q{//div[title="#{@book_name}}) do
    steps %Q{
      Then I should see "total: #{number}"
    }
  end
end

Then /^I should see "([^"]*)" units were sold by "([^"]*)"$/ do |number, vendor|
  within(:css, %Q{div[@title="#{@book_name}"]}) do
    steps %Q{
      Then I should see "#{vendor}: #{number}"
    }
  end
end

Then /^I should see "([^"]*)" were earned on "([^"]*)"$/ do |money, vendor|
  within(:css, %Q{div[@title="#{@book_name}"]}) do
    regexp_str = "#{Regexp.quote(vendor)}.*#{Regexp.quote(money)}"
    steps %Q{
      Then I should see /#{regexp_str}/
    }
  end
end

Then /^I should see "([^"]*)" units were sold in "([^"]*)"$/ do |number, month|
  within(:css, %Q{div[@title="#{@book_name}"] .#{month} .total}) do
    steps %Q{
      Then I should see "#{number}"
    }
  end
end

Then /^I should see "([^"]*)" units were sold in "([^"]*)" by "([^"]*)"$/ do |number, month, vendor|
  within(:css, %Q{div[@title='#{@book_name}'] .month[@title*='#{month}']}) do
    steps %Q{
      Then I should see "#{vendor}: #{number}"
    }
  end
end
