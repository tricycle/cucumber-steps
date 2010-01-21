#---------- VIEWS

Then /^I should be forwarded to "([^\"]*)"$/ do |path|
  request.env["PATH_INFO"].should == path
end

Then /^I should see the "([^\"]*)" link$/ do |link_title|
  response.should have_tag("a", :text => link_title)
end

Then /^I should not see the "([^\"]*)" link$/ do |link_title|
  response.should_not have_tag("a", :text => link_title)
end

Then /^I should see the "([^\"]*)" link to (.*)$/ do |link_title, link_page|
  response.should have_tag("a[href=#{path_to(link_page)}]", :text => link_title)
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
