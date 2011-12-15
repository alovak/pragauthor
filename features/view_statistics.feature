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

  Background:
    Given today is "08 Jul 2011"
    Given I sign in as "Inez"

  Scenario: view totals for uploaded files
    Given I upload "kdp-report-04-2011.xls"
    Then I should see "208"
    And I should see "75.09"




