Given /^today is "([^"]*)"$/ do |date|
  Timecop.travel(DateTime.parse(date))
end
