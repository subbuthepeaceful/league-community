##############
Given /^I am a non\-logged in User$/ do
  u = 1
end

Given /^I am an Admin User$/ do
  user = User.find(:first, :conditions => { :superadmin => true })
end

#############
When /^I navigate to the Admin URL$/ do
  visit '/admin'
end

When /^I navigate to the Age Groups URL$/ do
  visit '/admin/age_groups'
end

############
Then /^I should see the Admin Login$/ do
  # TO DO
end

Then /^I should see a list of Age Groups$/ do
  #TO DO
end
