#---------- MODELS
# Given there is a [model]
# Given there is a [model] with [field] "[value]"
# Given there is a [model], associated [field] with [record]
# Given the [model] has the [field] "[value]"
# Given there are [models] from the following table
# 
# Given the [model] is deleted
# Given there is not a [model] with [field] "[value]"
# Given there are no [models]
# 
# Given there are "[size]" [models]
# 
# When I enter a valid [model] [field] into "[form_field]"
# 
# Then I should see the [model] field [field]
# Then I should not see the [model] field [field]
# Then I should see the [model] fields [field,field]
# Then the "[field]" field should be blank
# 
# Then there should be an assigned [model]
# Then there should be an assigned [model] with [field] "[field_value]"
#

############################
Given /^there is (?:a|an) ([^\ ]*)$/ do |model|
  klass = Kernel.const_get(model.classify)
  klass.should_not be_nil
  
  tmp_model = klass.make
  instance_variable_set("@#{model}", tmp_model)
end

Given /^there is (?:a|an) ([^\ ]*) with ([^\ ]*) "([^\"]*)"$/ do |model, field, value|
  klass = Kernel.const_get(model.singularize.classify)
  klass.should_not be_nil

  tmp_model = klass.make(field.to_sym => value)
  instance_variable_set("@#{model}", tmp_model)
end

Given /^there is (?:a|an) ([^\ ]*) from ([^\ ]*) as ([^\ ]*)$/ do |model, record, field|
  klass = Kernel.const_get(model.singularize.classify)
  klass.should_not be_nil
  
  tmp_model = klass.make(field.to_sym => instance_variable_get("@#{record}"))
  instance_variable_set("@#{model}", tmp_model)
end

Given /^the ([^\ ]*) has the ([^\ ]*) "([^\"]*)"$/ do |model, field, value|
  instance_variable_get("@#{model}").update_attribute field.to_sym, value
end

Given /^the ([^\ ]*) has no ([^\ ]*)$/ do |model, field|
  instance_variable_get("@#{model}").update_attribute field.to_sym, nil
end

Given /^there are ([^\ ]*) from the following table$/ do |model, table|
  klass = Kernel.const_get(model.singularize.classify)
  klass.should_not be_nil

  table.hashes.each do |item|
    klass.make(item)
  end
end

############################
Given /^the ([^\ ]*) is deleted$/ do |model|
  tmp_model = instance_variable_get("@#{model}")
  tmp_model.should_not be_nil

  tmp_model.destroy
end

Given /^there is not a ([^\ ]*) with ([^\ ]*) "([^\"]*)"$/ do |model, field, value|
  klass = Kernel.const_get(model.singularize.classify)
  klass.should_not be_nil

  klass.find(:all, :conditions => ["#{field} = ?", value]).each(&:destroy)  
end

Given /^there are no ([^\ ]*)$/ do |models|
  klass = Kernel.const_get(models.classify)
  klass.should_not be_nil

  klass.destroy_all(false)
end

############################
Given /^there are "(.*)" (.*)$/ do |size, models|
  klass = Kernel.const_get(models.classify)
  klass.should_not be_nil

  records = klass.find(:all)
  # add required users
  records.length.upto(size.to_i - 1) do
    records << klass.make
  end  

  instance_variable_set("@#{models.pluralize}", records)
  records
end

############################
When /^I enter a valid (.*) (.*) into "([^\"]*)"$/ do |model, field, form_field|
  klass = Kernel.const_get(model.classify)
  klass.should_not be_nil

  tmp_model = klass.make_unsaved  
  fill_in(form_field, :with => tmp_model[field.to_sym]) 
end

Given /^I have entered valid (article|case) details$/ do |model|
  fill_in('Title', :with => 'Valid Title')
  fill_in("#{model.classify} Content", :with => '<p>Some sample content.</p>')
end

Given /^I have entered invalid ([^ ]+) details$/ do |model|
  # Just leave blank?
end

Given /^there is a revision for the ([^\ ]*) with ([^\ ]*) "([^\"]*)"$/ do |model, field, value|
  obj = instance_variable_get("@#{model}")
  obj.update_attribute field, value
  @revision = obj.revision_records.last
end

############################
Then /^I should see the ([^\ ]*) field ([^\ ]*)$/ do |model, field|
  tmp_model = instance_variable_get("@#{model}")
  tmp_model.should_not be_nil

  response.should contain(tmp_model[field.to_sym])
end

Then /^I should not see the ([^\ ]*) field ([^\ ]*)$/ do |model, field|
  tmp_model = instance_variable_get("@#{model}")
  tmp_model.should_not be_nil

  response.should_not contain(tmp_model[field.to_sym])
end

Then /^I should see the ([^ ]*) fields ([^ ]+,[^ ]+)$/ do |model, fields|
  tmp_model = instance_variable_get("@#{model}")
  tmp_model.should_not be_nil

  fields.split(',').each do |field|
    response.should contain(tmp_model[field.to_sym])
  end  
end

Then /^the "([^\"]*)" field should be blank$/ do |field|
  field_labeled(field).value.should be_blank
end

Then /^I should see the "([^\"]*)" field$/ do |field|
  field_labeled(field).should_not be_nil
end

############################
Then /^there should be an assigned ([^\ ]*)$/ do |model|  
  assigns[model].should_not be_nil  
end

Then /^there should be an assigned ([^\ ]*) with (.*) "([^\"]*)"$/ do |model, field, field_value|  
  assigns[model].should_not be_nil  
  assigns[model].send(field.to_sym).should == field_value
end

Given /^the ([^ ]+) (?:is in|has) the (section|system|tag)$/ do |model, tag|
  model = instance_variable_get("@#{model}")
  tag = instance_variable_get("@#{tag}")
  tagging = Tagging.make(:taggable => model, :tag => tag, :tag_type => model.class.name.pluralize)
end

Then /^the assigned ([^ ]+) should (?:be in|have) the (section|system|tag) "([^\"]*)"$/ do |model, tag_class_name, name|
  content = assigns[model]
  content.should_not be_nil
  tag_class = Kernel.const_get(tag_class_name.singularize.classify)
  tag = tag_class.find(:first, :conditions => {:name => name})
  content.send(tag_class_name.downcase.pluralize.to_sym).include?(tag).should be_true
end

Then /^the assigned ([^ ]+) should have the reference "([^\"]*)"$/ do |model, reference_text|
  content = assigns[model]
  content.should_not be_nil
  content.references.first.citation.should == reference_text
end

Then /^the assigned ([^ ]+) should have the synonym "([^\"]*)"$/ do |model, synonym|
  content = assigns[model]
  content.should_not be_nil
  content.synonyms.first.title.should == synonym
end

############################
Given /^the Ferret index is rebuild$/ do
  Content.rebuild_index
end
