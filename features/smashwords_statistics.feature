Feature:
  As Inez
  I want to upload Smashwords files
  In order to view sale statistics

  Background:
    Given I sign in as "Inez"

  Scenario: see Smashwords total statistics for uploaded books
    Given I upload "SmashWords_salesReport-2011-06-08.xls"
    When I look statistics for "The First Book"
    Then I should see "N" units were sold by "Smashwords"
    When I look statistics for "The Second Book"
    Then I should see "M" units were sold by "Smashwords"

  # Scenario: see monthly statistics for uploaded books
    # Given I upload "BNsales_May2011.xls"
    # And I upload "BNsales_June2011.xls"
    # When I look statistics for "The First Book"
    # Then I should see "8" units were sold in "May" by "Barnes&Noble"
    # Then I should see "3" units were sold in "Jun" by "Barnes&Noble"
    # When I look statistics for "The Second Book"
    # Then I should see "11" units were sold in "May" by "Barnes&Noble"
    # Then I should see "18" units were sold in "Jun" by "Barnes&Noble"
