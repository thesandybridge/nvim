(quoted_attribute_value
  (attribute_value) @phpCode
  (#match? @phpCode ".*\\$.*")
  (#set! phpCode.highlight "phpCode"))
