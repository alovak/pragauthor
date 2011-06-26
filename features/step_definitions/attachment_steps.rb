When /^I upload "([^"]*)"$/ do |file|
  When %{I attach the file "features/support/files/#{file}" to "Report"}
end
