const std = @import("std");
const parser = @import("parser.zig");

pub fn main() !void {
    const timer = try std.time.Timer.start();

    var it = try parser.ParserIterator(5, '\n').init("../input/01.txt");
    defer it.close();

    var previous: u16 = 65535; // u16 max
    var num_increases: u16 = 0;

    while (try it.next()) |line| {
        const number = try std.fmt.parseUnsigned(u16, line, 10);
        if (number > previous) num_increases += 1;
        previous = number;
    }

    const time: u64 = timer.read();

    std.debug.print("{}\n", .{num_increases});
    std.debug.print("time: {}", .{time});
}
