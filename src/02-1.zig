const std = @import("std");
const parser = @import("parser.zig");

pub fn main() !void {
    const timer = try std.time.Timer.start();

    var it = try parser.ParserIterator(10, '\n').init("../input/02.txt");
    defer it.close();

    var horizontal: u32 = 0;
    var depth: u32 = 0;
    while (try it.next()) |line| {
        var word_it = std.mem.split(u8, line, " ");

        const word = word_it.next().?;
        const number = try std.fmt.parseUnsigned(u16, word_it.next().?, 10);

        if (std.mem.eql(u8, word, "forward")) {
            horizontal += number;
        } else if (std.mem.eql(u8, word, "up")) {
            depth -= number;
        } else if (std.mem.eql(u8, word, "down")) {
            depth += number;
        }
    }

    const result: u32 = horizontal * depth;
    const time: u64 = timer.read();

    std.debug.print("horizontal: {}, depth: {}, result: {}\n", .{ horizontal, depth, result });
    std.debug.print("ns used: {}", .{time});
}
