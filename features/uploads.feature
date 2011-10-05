Feature:
  As Inez
  I want to view all my uploads
  In order to see which files I already uploaded

  Scenario: see Barnes&Noble total statistics for uploaded books
    Given I sign in as "Inez"
    And I upload "BNsales_June2011.xls"
    When I go to the uploads page
    Then I should see "BNsales_June2011.xls"
