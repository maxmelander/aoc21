const std = @import("std");
const parser = @import("parser.zig");
const file = @embedFile("../input/01.txt");

pub fn main() !void {
    const timer = try std.time.Timer.start();

    var it = std.mem.tokenize(u8, file, "\n");

    var previous: u16 = 65535; // u16 max
    var num_increases: u16 = 0;

    while (it.next()) |line| {
        const number = try std.fmt.parseUnsigned(u16, line, 10);
        if (number > previous) num_increases += 1;
        previous = number;
    }

    const time: u64 = timer.read();

    std.debug.print("{}\n", .{num_increases});
    std.debug.print("time: {}", .{time});
}
