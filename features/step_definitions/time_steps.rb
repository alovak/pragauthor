Given /^today is "([^"]*)"$/ do |date|
  Timecop.travel(Chronic.parse(date))
end
