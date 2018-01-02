Feature: AverageAge

Scenario: Two people with the same age
	Given I have persons:
	| Name | Age |
	| Bob  | 5   |
	| Jane | 5   |
	When I query for average age
	Then I expect the result to be:
	| Average     |
	| 5           |
