When /^I upload "([^"]*)"$/ do |file|
  When %{I attach the file "features/support/files/#{file}" to "Report"}
  And %{I press "Create Upload"}
end
