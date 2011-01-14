#---------- VIEWS

Then /^I should be forwarded to "([^\"]*)"$/ do |path|
  request.env["PATH_INFO"].should == path
end

Then /^I should see a "([^\"]*)" button$/ do |title|
  if title =~ /^Choose File$/
    response.should have_tag("input[type=file]")
  else
    response.should have_tag("*[value=#{title}]")
  end
end

Then /^I should not see a "([^\"]*)" button$/ do |title|
  response.should_not have_tag("*[value=#{title}]")
end
