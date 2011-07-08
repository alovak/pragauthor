When /^I upload "([^"]*)"$/ do |file|
  steps %Q{
    When I attach the file "features/support/files/#{file}" to "Report"
    And I press "Create Upload"
    Then I should see "You file was uploaded and processed"
  }
end
