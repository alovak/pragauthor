Feature:
  As Inez
  I want to upload Barnes&Noble files
  In order to view sale statistics

  Background:
    Given I sign in as "Inez"

  Scenario: see total statistics
    When I upload "BNsales_May2011.xls"
    Then I should see "You file was uploaded and processed"
    When I upload "BNsales_June2011.xls"
    Then I should see "You file was uploaded and processed"
    When I look statistics for the "First Book"
    Then I should see "11" units were sold total
    And I should see "11" units were sold by "Barnes&Noble"
    And I should see "8" units were sold by "Barnes&Noble" in "May"
    And I should see "3" units were sold by "Barnes&Noble" in "June"

  Scenario: upload file with two books
