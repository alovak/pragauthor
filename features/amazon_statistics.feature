Feature:
  As Inez
  I want to upload amazon files
  In order to view sale statistics

  Background:
    Given I sign in as "Inez"

  Scenario: see total statistics
    When I upload "kdp-report-04-2011.xls"
    Then I should see "You file was uploaded and processed"
    When I upload "kdp-report-05-2011.xls"
    Then I should see "You file was uploaded and processed"
    When I look statistics for the "First Book"
    Then I should see "190" units were sold total
    And I should see "190" units were sold by "Amazon"
    And I should see "100" units were sold in "April"
    And I should see "90" units were sold in "May"
    And I should see "100" units were sold by "Amazon" in "April"
    And I should see "90" units were sold by "Amazon" in "May"

  Scenario: upload file with two books
