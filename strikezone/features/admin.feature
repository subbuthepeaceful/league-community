Feature: Administrative Interface
  In order to administer the club soccer application
  As an Admin User
  I want to login to the administrative interface

  Scenario: Access the Admin Interface
    Given I am a non-logged in User
    When I navigate to the Admin URL
    Then I should see the Admin Login

  Scenario: Manage Age Groups
    Given I am an Admin User
    When I navigate to the Age Groups URL
    Then I should see a list of Age Groups 
