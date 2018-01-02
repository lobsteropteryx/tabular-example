Feature: AverageAge
  Calculating the average age of people

Scenario: A single person
	Given I have persons:
	| Name | Age |
	| Bob  | 5   |
	When I query for average age
	Then I expect the result to be:
	| Average     |
	| 5           |

Scenario: Two people with the same age
	Given I have persons:
	| Name | Age |
	| Bob  | 5   |
	| Jane | 5   |
	When I query for average age
	Then I expect the result to be:
	| Average     |
	| 5           |

Scenario: Blank ages are treated as zero
	Given I have persons:
	| Name | Age |
	| Bob  | 5   |
	| Jane |     |
	When I query for average age
	Then I expect the result to be:
	| Average |
	| 2.5     |