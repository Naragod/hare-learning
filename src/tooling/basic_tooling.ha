use fmt;
use bufio;
use os;
use fs;
use io;
use strings;

export fn to_string(byte_input: []u8) str = {
    return match(strings::fromutf8(byte_input)){
        case let result: str => yield result;
        case => yield "";
    };
};

export fn read_line() str = {
    return match(bufio::read_line(os::stdin)){
        case io::EOF => yield "__end__";
        case let err: io::error => yield "__end__";
        case let user_input: []u8 => 
            yield to_string(user_input);
    };
};

export fn read_byte() str = {
    return match(bufio::read_byte(os::stdin)){
        case io::EOF => yield "__end__";
        case let err: io::error => yield "__end__";
        case let user_input: u8 => 
            yield strings::join(to_string([user_input]), "\n"): str;
    };
};

export fn clear_screen() void = {
    fmt::print("\x1b[2J\x1b[H")!;
};