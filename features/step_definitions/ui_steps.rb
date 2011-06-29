When /^I look statistics for the "([^"]*)"$/ do |book|
  steps %Q{
    Then I should see "#{book}"
  }
end

