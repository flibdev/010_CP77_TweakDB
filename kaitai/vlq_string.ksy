meta:
  id: vlq_string
  endian: le
  title: Length-Prefixed String
  imports:
    - vlq_int32

doc: |
  Length-prefixed String format used by the RED4 engine.
  The length and character format are stored in a VLQ Int32.

seq:
  - id: prefix
    type: vlq_int32
  - id: data
    size: prefix.abs_value

instances:
  length:
    value: prefix.abs_value
    doc: The length of the string in bytes
  encoding:
    value: >-
      prefix.is_negative ? "UTF-8" : "UTF16-LE"
  value:
    value: data.to_s(encoding)
    doc: |
      String encoding is denoted by the sign of the length value:
       - Negative lengths store UTF8 encoded strings.
       - Positive lengths store UTF16-LE encoded strings
