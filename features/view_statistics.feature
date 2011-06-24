Feature:
  As Inez
  I want to upload files
  In order to view sale statistics

  # The following type of reports our user ()
  # would like to get:
  #
  # How many of the title sold total that month
  # How many of the title sold on each site (Apple, Sony, Kobo, Kindle and so on…) that month.
  # How much money I made on that title that month.
  # How many books I sold total that month.
  # A comparison of the sales from month to month of each title and overall sales.

  # Questions:
  # do we need to split Amzon sales to UK/DE Kindle stores
  # or just leave as Amazon?
  Scenario: upload amazon file and review statistics
    Given Inez is a registered user
    When I sign in
    Then I should see "Upload file"
    When I upload "kdp-report-04-2011.xls"
    Then I should see "You file was uploaded and processed"
    When I look statistics for the "Tempest"
    Then I should see "190" units were sold total
    And I should see "190" units were sold in "May"
    And I should see "190" units were sold by "Amazon" in "May"
    
    When I look statistics for the "Desert Heat"
    Then I should see "13" units were sold total
    And I should see "13" units were sold in "May"
    And I should see "13" units were sold by "Amazon" in "May"

    When I look statistics for the "The Entertainer (Working Stiffs)"
    Then I should see "5" units were sold total
    And I should see "5" units were sold in "May"
    And I should see "5" units were sold by "Amazon" in "May"
