Feature: Download receipt_ticket
  In order to allow registration to flow better at the conference registrations
  paying participants
  wants to download their tickets and a receipt as PDF
  
  Scenario: Generate receipt_ticket
    Given I am logged in as "user" 
    And I am on the "/users/current" profile page
    And I do not have a receipt_ticket
    When I press "Generate receipt/ticket"
    Then I should see "Generating ticket..."
    
  Scenario: Download receipt_ticket
    Given I have generated my receipt_ticket
    Then I should see "Download receipt/ticket"
    When I click "Download receipt/ticket"
    Then I should receive my PDF ticket