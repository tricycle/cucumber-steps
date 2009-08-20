#---------- MODELS


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
