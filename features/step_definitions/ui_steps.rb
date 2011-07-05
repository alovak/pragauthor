When /^I look statistics for the "([^"]*)"$/ do |book|
  steps %Q{
    Then I should see "#{book}"
  }
end

Then /^I should see "([^"]*)" units were sold total$/ do |number|
  steps %Q{
    Then I should see "total: #{number}"
  }
end

Then /^I should see "([^"]*)" units were sold by "([^"]*)"$/ do |number, vendor|
  steps %Q{
    Then I should see "#{vendor}: #{number}"
  }
end
