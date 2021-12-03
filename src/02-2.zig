const std = @import("std");
const file = @embedFile("../input/02.txt");

pub fn main() !void {
    const timer = try std.time.Timer.start();

    var it = std.mem.tokenize(u8, file, "\n");

    var horizontal: u32 = 0;
    var depth: u32 = 0;
    var aim: u32 = 0;
    while (it.next()) |line| {
        var word_it = std.mem.split(u8, line, " ");

        const word = word_it.next().?;
        const number = try std.fmt.parseUnsigned(u16, word_it.next().?, 10);

        if (std.mem.eql(u8, word, "forward")) {
            horizontal += number;
            depth += aim * number;
        } else if (std.mem.eql(u8, word, "up")) {
            aim -= number;
        } else if (std.mem.eql(u8, word, "down")) {
            aim += number;
        }
    }

    const result: u32 = horizontal * depth;
    const time: u64 = timer.read();

    std.debug.print("horizontal: {}, depth: {}, result: {}\n", .{ horizontal, depth, result });
    std.debug.print("ns used: {}", .{time});
}
