meta:
  id: tweakdbid
  endian: le
  title: Cyberpunk 2077 TweakDB ID type

seq:
  - id: name_hash
    type: u4
    doc: CRC-32 "hash" of the key name string
  - id: name_length
    type: u1
    doc: Length of the key name string
  - id: unknown
    type: u3
    doc: Currently unknown padding bytes
