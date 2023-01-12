
#include <std/mem.pat>

#define VLQ_NEGATIVE        0b10000000
#define VLQ_CONTINUATION_1  0b01000000
#define VLQ_CONTINUATION_N  0b10000000
#define VLQ_VALUEMASK_1     0b00111111
#define VLQ_VALUEMASK_N     0b01111111


fn HasFlag(u8 b, u8 flag) {
    return (b & flag) == flag;
};

fn ReadVLQInt32(u128 addr, bool consumeAddr) {
    u8 b = std::mem::read_unsigned(addr, 1);
    u8 isNegative = b & VLQ_NEGATIVE;

    i32 value = b & VLQ_VALUEMASK_1;

    if ( HasFlag(b, VLQ_CONTINUATION_1) ) {
        addr++;
        b = std::mem::read_unsigned(addr, 1);
        value |= (i32)(b & VLQ_VALUEMASK_N) << 6;

        if ( HasFlag(b, VLQ_CONTINUATION_N) ) {
            addr++;
            b = std::mem::read_unsigned(addr, 1);
            value |= (i32)(b & VLQ_VALUEMASK_N) << 13;

            if ( HasFlag(b, VLQ_CONTINUATION_N) ) {
                addr++;
                b = std::mem::read_unsigned(addr, 1);
                value |= (i32)(b & VLQ_VALUEMASK_N) << 20;

                if ( HasFlag(b, VLQ_CONTINUATION_N) ) {
                    addr++;
                    b = std::mem::read_unsigned(addr, 1);
                    value |= (i32)(b & VLQ_VALUEMASK_N) << 27;

                    if ( HasFlag(b, VLQ_CONTINUATION_N) ) {
                        std::error("VLQ Error: Continuation bit set on 5th byte")
                    }
                }
            }
        }
    }

    if (consumeAddr) {
        $ = addr + 1;
    }

    return isNegative ? -value : value;
};

fn ReadLengthPrefixedString(u128 addr) {
    i32 prefix = ReadVLQInt32(addr, true);

};
