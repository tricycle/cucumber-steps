#---------- DEBUG
# Then debug page
# Then debug page text

Then /^debug page$/ do
  debug_page
end

Then /^debug page text$/ do
  debug_page_text
end

Then /^warning "([^\"]*)"$/ do |msg|
  warning(msg)
end
