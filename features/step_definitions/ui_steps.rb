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
