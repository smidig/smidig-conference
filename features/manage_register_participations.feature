Feature: Manage register_participations
  In order to [goal]
  [stakeholder]
  wants [behaviour]
  
  Scenario: Register new register_participation
    Given I am on the new register_participation page
    When I fill in "Email" with "email 1"
    And I press "Create"
    Then I should see "email 1"

  Scenario: Delete register_participation
    Given the following register_participations:
      |email|
      |email 1|
      |email 2|
      |email 3|
      |email 4|
    When I delete the 3rd register_participation
    Then I should see the following register_participations:
      |email|
      |email 1|
      |email 2|
      |email 4|
