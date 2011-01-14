When /^I visit "([^"]+)"$/ do |path|
  visit path
end

Then /^I should be redirected to "([^"]+)"$/ do |path|
  URI.parse(current_url).path.should == path
  page.driver.response.status.should == 200
end

Then /^it should have "([^"]+)" as the query string$/ do |query|
  URI.decode(URI.parse(current_url).query).should == query
end

Then /^it should have no query string$/ do
  URI.parse(current_url).query.should be_blank
end

Then /^(?:|I )should not be on (.+)$/ do |page_name|
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should_not == path_to(page_name)
  else
    assert_not_equal path_to(page_name), current_path
  end
end
