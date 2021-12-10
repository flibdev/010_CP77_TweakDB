meta:
  id: vlq_uint32
  endian: le
  title: Variable-Length Quantity Uint32

doc: Variable-Length Quantity Unsigned 32-bit integer format used by the RED4 engine

types:
  vlq_ubyte:
    doc: |
      One byte block, divided into:
       - 1-bit continuation flag
       - 7-bits of integer value
    seq:
      - id: b
        type: u1
    instances:
      has_next:
        value: (b & 0b1000_0000) != 0
        doc: If true, we have additional bytes to read
      value:
        value: b & 0b0111_1111
        doc: The 7-bits of data stored

seq:
  - id: bytes
    type: vlq_ubyte
    repeat: until
    repeat-until: not _.has_next

instances:
  length:
    value: bytes.size
    doc: Size of the value in bytes
  value:
    value: >-
      bytes[0].value
      + (length > 1 ? (bytes[1].value <<  7) : 0)
      + (length > 2 ? (bytes[2].value << 14) : 0)
      + (length > 3 ? (bytes[3].value << 21) : 0)
      + (length > 4 ? (bytes[4].value << 27) : 0)
    doc: The decoded uint32 value
