#include <std/io.pat>
#include <std/sys.pat>

// format string helpers
fn as_hex32(u32 u) {
    return std::format("0x{:08X}", u);
};

fn as_hex64(u64 u) {
    return std::format("0x{:016X}", u);
};

//------------------------------------------------------------------------------
// TweakDBID
// 64bit ID Hash to a record or a record flat (based on offset)
// Hash is stored as a CRC32 hash of the record name

struct TDBID_Composite {
    u32 nameHash;
    u8 nameLength;
    u8 dataOffset[3];
} [[static]];

union TDBID {
    u64 hash;
    TDBID_Composite composite;
} [[static, format("format_TDBID")]];

fn format_TDBID(TDBID t) {
    return std::format(
        "<TDBID:{:08X}:{:02X}>",
        t.id.composite.nameHash,
        t.id.composite.nameLength
    );
};


struct TDBID_Index {
    TDBID id;
    u32 index;
} [[static, format("format_TDBID_Index")]];

fn format_TDBID_Index(TDBID_Index ti) {
    return std::format(
        "{} -> {}",
        format_TDBID(ti.id),
        ti.index
    );
};


struct TDBID_Schema {
    TDBID id;
    u32 schema;
} [[static, format("format_TDBID_Schema")]];

fn format_TDBID_Schema(TDBID_Schema ts) {
    return std::format(
        "{} -> {:08X}",
        format_TDBID(ts.id),
        ts.schema
    );
};


//------------------------------------------------------------------------------
// Flat Type Declaration
// Stored as a CName hash to a known RTTI type




//------------------------------------------------------------------------------
// Header format

struct TweakDB_Header {
    u32 magic [[comment("4 7DB B10B = A TDB BLOB")]];
    std::assert(magic == 0x0BB1DB47, "Incorrect header magic");
    
    u32 blobVersion;
    u32 parserVersion;
    u32 recordsChecksum;
    
    u32 offsetFlats;
    u32 offsetRecords;
    u32 offsetQueries;
    u32 offsetGroupTags;
} [[single_color]];

//------------------------------------------------------------------------------
// TweakDB binary file structure

struct TweakDB {
    TweakDB_Header header;
};

TweakDB tweakdb @ 0x00;

