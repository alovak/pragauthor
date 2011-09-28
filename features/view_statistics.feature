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
    Given I sign in as "Inez"

  Scenario: show welcome message and instructions how to use application
  Scenario: upload amazon file and view statistics
  Scenario: upload Barnes & Noble file and view statistics
  Scenario: upload Smashwords file and view statistics

  Scenario: upload file with unknown name
    When I upload "unknown.txt"
    Then I should see "Unfortunately, we can't process your file"
    # And I should see what I can do with it now


