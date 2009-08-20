#---------- ERRORS
# Then I should see the form errors
# Then I should see an error message
# Then I should see the error message "[message]"
# Then I should see a success message
# Then I should see the success message "[message]"
# Then I should see a warning message
# Then I should see the warning message "[message]"
#

Then /^I should see the form errors$/ do
  response.should have_tag('div[class=errorExplanation]')
end

Then /^I should see an error message$/ do
  response.should have_tag('div[id=flashError]')
end

Then /^I should see the error message "([^\"]*)"$/ do |msg|
  response.should have_tag('div[id=flashError]', msg)
end

Then /^I should see a success message$/ do
  response.should have_tag('div[id=flashSuccess]')
end

Then /^I should see the success message "([^\"]*)"$/ do |msg|
  response.should have_tag('div[id=flashSuccess]', msg)
end

Then /^I should see a warning message$/ do
  response.should have_tag('div[id=flashNotice]')
end

Then /^I should see the warning message "([^\"]*)"$/ do |msg|
  response.should have_tag('div[id=flashNotice]', msg)
end
