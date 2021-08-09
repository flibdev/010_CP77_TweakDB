# 010_CP77_TweakDB

[010 Editor](https://www.sweetscape.com/010editor/) binary templates for reading the Cyberpunk 2077 `tweakdb.bin` file

Still work-in-progress, currently `CP77_TweakDB.bt` can:
 - Read the header
 - Read the flat types and quantities
 - Read the flat values and their lookup keys
 - Read the record hashes and types
 - Read the queries and their record lists
 - Read the group tags and their mystery byte of value

Doesn't currently support:
 - Changing any values
 - Checking the records checksum
