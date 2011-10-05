Feature:
  As Inez
  I want to upload files
  In order to view sale statistics

  Background:
    Given I sign in as "Inez"

  Scenario: upload file with unknown name
    When I upload "unknown.txt"
    Then I should see "Unfortunately, we can't process your file"
    And I should see what can I do with it now
    And I should see "welcome@pragauthor.com"
    # And admin should receive email with link to file
