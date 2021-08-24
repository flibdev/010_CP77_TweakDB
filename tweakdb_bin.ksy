meta:
  id: tweakdb_bin
  endian: le
  title: Cyberpunk 2077 TweakDB binary cache format
  file-extension: bin

doc: |
  tweakdb.bin is the serialized binary format for TweakDB,
  the read-only pooled data cache used by Cyberpunk 2077

seq:
  - id: header
    type: header
  - id: flats
    type: flats
    pos: header.ofs_flats
  - id: records
    type: records
    pos: header.ofs_records
  - id: queries
    type: queries
    pos: header.ofs_queries
  - id: group_tags
    type: group_tags
    pos: header.ofs_group_tags

types:
  header:
    seq:
      - id: magic
        type: u4
        contents: [0x47, 0xDB, 0xB1, 0x0B]
        doc: A TDB BLOB - Magic l33t sp34k string
      - id: blob_version
        type: u4
        contents: [0x05]
        doc: This schema only supports blob version 5
      - id: parser_version
        type: u4
        doc: This schema only supports parser version 4
      - id: records_checksum
        type: u4
        doc: |
          Composite checksum value of all the record schemas.
          Should be constant for a specific game version.
      - id: ofs_flats
        type: u4
        doc: File offset to start of flats
      - id: ofs_records
        type: u4
        doc: File offset to start of records
      - id: ofs_queries
        type: u4
        doc: File offset to start of queries
      - id: ofs_group_tags
        type: u4
        doc: File offset to start of group tags

  flats:
    seq:
      - id: num_flat_types
        type: u4
        doc: Number of flat data types stored in the TweakDB
      - id: flat_types
        type: flat_type
        repeat: expr
        repeat-expr: num_flat_types
      - id: flats
        repeat: expr
        repeat-expr: num_flat_types
        type: flat_map(flat_types[_index].hash)

  flat_type:
    seq:
      - id: hash
        type: u8
        enum: flat_types
        doc: CName hash (FNV-1a 64) of the data type name
      - id: num_flats
        type: u4
        doc: Number of flat values of this data type

  flat_map:
    params:
      - id: type_hash
        type: u8
        enum: flat_types
        doc: CName hash of the data type name
    seq:
      - id: num_flat_values
        type: u4
        doc: Number of flat values of this type in the constant pool
      - id: values
        doc: Array of flat values
        repeat: expr
        repeat-expr: num_flat_values
        type:
          switch-on: type_hash
          cases:
            bool:   flat_type_bool
            int32:  flat_type_int32
            float:  flat_type_float
            string: flat_type_string
            cname:  flat_type_string
            resref: flat_type_resref
            lockey: flat_type_lockey
            tweakdbid: flat_type_tweakdbid
            vector2:   flat_type_vector2
            vector3:   flat_type_vector3
            quaternion: flat_type_quaternion
            euler_angles: flat_type_euler_angles

            array_bool:   flat_type_array(flat_type_bool)
            array_int32:  flat_type_array(flat_type_int32)
            array_float:  flat_type_array(flat_type_float)
            array_string: flat_type_array(flat_type_string)
            array_cname:  flat_type_array(flat_type_string)
            array_resref: flat_type_array(flat_type_resref)
            array_tweakdbid: flat_type_array(flat_type_tweakdbid)
            array_vector2: flat_type_array(flat_type_vector2)
            array_vector3: flat_type_array(flat_type_vector3)

  flat_type_bool:
    seq:
      - id: value
        type: u1
        doc: Boolean stored as either 0 (false) or 1 (true)

  flat_type_int32:
    seq:
      - id: value
        type: i4
        doc: 32-bit Signed Integer

  flat_type_float:
    seq:
      - id: value
        type: f4
        doc: 32-bit IEEE 754 single-precision floating-point type

  flat_type_string:
    seq:
      - id: values
        type: length_prefixed_string

  flat_type_resref:
    seq:
      - id: value
        type: u8
        doc: CName hash to an archive resource

  flat_type_lockey:
    seq:
      - id: value
        type: u8
        doc: |
          LocKey# index value
          Some values seem to have full CName hashes instead of keys

  flat_type_tweakdbid:
    seq:
      - id: value
        type:

  flat_type_vector2:
    seq:
      - id: value
        type:

  flat_type_vector3:
    seq:
      - id: value
        type:

  flat_type_quaternion:
    seq:
      - id: value
        type:

  flat_type_euler_angles:
    seq:
      - id: value
        type:


  flat_type_array:
    seq:
      - id: values
        type:



  length_prefixed_string:
    doc: |
      CDPR use a length-prefixed string
    seq:
      - id: len_prefix
        type: u1
        doc: |
          The first byte 
    instances:
      has_wide_chars:
        value: len_prefix & 0b1000_0000

enums:
  flat_types:
    0xf7bdd5a7c820889d: bool
    0xb9a127f5b4a621bf: int32
    0xb64f4a0accc8a8c5: float
    0x58b4b3ecd4eb6238: string
    0xa5e23de2a2657af9: cname
    0xaf78d916d59a1e5e: resref
    0xc5527ad607d034ed: lockey
    0x4072151ff3dcf7bc: tweakdbid
    0x679f6b8bb9083ff0: vector2
    0x679f6c8bb90841a3: vector3
    0xf1c0252cffe275cd: quaternion
    0x527459e8b7d4f756: euler_angles

    0x272d3f5dbedec48c: array_bool
    0xa1ed713e69fb24d8: array_int32
    0xba0ef953a5018666: array_float
    0x91e86ab153877615: array_string
    0x24d1e72a8bbe64d6: array_cname
    0xbf98c02523e2073d: array_resref
    0x2e57de748521342f: array_tweakdbid
    0xdc6f7517bd4358d3: array_vector2
    0xdc6f7417bd435720: array_vector3
