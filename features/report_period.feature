@time_travel
Feature:
  As Inez
  In order to view sales for different periods
  I want to set period for reports

  Background:
    Given I have a sales for long period

  Scenario: I see monthly sales for the last 6 month when I navigate to dashboard
    When I navigated to dashboard
      Then I should see total sales
      And I should see monthly sales for the last year

  Scenario: I can select period with months for monthly sales
    When I navigated to dashboard
    And I set period for the last 5 months
      Then I should see total sales
      And I should see monthly sales for the last 5 months
