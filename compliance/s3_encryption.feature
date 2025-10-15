Feature: Ensure S3 buckets are encrypted

  Scenario: S3 buckets must have encryption enabled
    Given I have AWS S3 Bucket defined
    Then it must contain server_side_encryption_configuration