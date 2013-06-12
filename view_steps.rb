#---------- VIEWS

Then /^I should be forwarded to "([^\"]*)"$/ do |path|
  request.env["PATH_INFO"].should == path
end

Then /^I should see the "([^\"]*)" link$/ do |link_title|
  page.should have_selector("a", :text => link_title)
end

Then /^I should not see the "([^\"]*)" link$/ do |link_title|
  page.should_not have_selector("a", :text => link_title)
end

Then /^I should see the "([^\"]*)" link to (.*)$/ do |link_title, link_page|
  page.should have_link(link_title, href: path_to(link_page))
end

Then /^I should see a "([^\"]*)" button$/ do |title|
  if title =~ /^Choose File$/
    page.should have_xpath("//input[@type='file']")
  else
    page.should have_xpath("//*[@value='#{title}']")
  end
end

Then /^I should not see a "([^\"]*)" button$/ do |title|
  page.should_not have_xpath("*[@value='#{title}']")
end

Then /^I should see a "([^"]*)" select$/ do |id|
  response.should have_tag("select[id=#{id}]")
end

Then /^"([^"]*)" select should have option "([^"]*)"$/ do |select_id, option|
  response.should have_tag("select[id=#{select_id}]") do
    with_tag("option", :value => option)
  end
end

Then /^"([^"]*)" select should have selected option "([^"]*)"$/ do |select_id, option|
  response.should have_tag("select[id=#{select_id}]") do
    with_tag("option", :value => option, :selected => "selected")
  end
end

When /^I choose option "([^"]*)" from select "([^"]*)"$/ do |option, select_id|
  select option, :from => select_id
end
