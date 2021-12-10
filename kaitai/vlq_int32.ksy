meta:
  id: vlq_int32
  endian: le
  title: Variable-Length Quantity Int32
  imports:
    - vlq_uint32

doc: Variable-Length Quantity Signed 32-bit integer format used by the RED4 engine

types:
  signed_byte:
    doc: |
      One byte block, divided into:
       - 1-bit sign flag
       - 1-bit continuation flag
       - 6-bits of integer value
    seq:
      - id: b
        type: u1
    instances:
      is_negative:
        value: (b & 0b1000_0000) != 0
        doc: If true, the value is negative
      has_next:
        value: (b & 0b0100_0000) != 0
        doc: If true, we have additional bytes to read
      value:
        value: b & 0b0011_1111
        doc: The 6-bits of data stored

seq:
  - id: first_byte
    type: signed_byte
  - id: extra_bytes
    type: vlq_uint32
    if: first_byte.has_next

instances:
  length:
    value: >-
      1 + (first_byte.has_next ? extra_bytes.length : 0)
    doc: Size of the value in bytes
  is_negative:
    value: first_byte.is_negative
    doc: Is the value negative?
  abs_value:
    value: >-
      first_byte.value
      + (first_byte.has_next ? (extra_bytes.value << 6) : 0)
    doc: The decoded int32 value, ignoring sign
  signed_value:
    value: >-
      is_negative ? -abs_value : abs_value
    doc: The decoded int32 value
