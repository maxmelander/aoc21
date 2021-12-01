const std = @import("std");

pub fn main() !void {
    const timer = try std.time.Timer.start();

    const file = try std.fs.cwd().openFile("01-input1.txt", .{ .read = true });
    defer file.close();

    var reader = std.io.bufferedReader(file.reader()).reader();

    var previous: u16 = 65535; // u16 max
    var num_increases: u16 = 0;

    var input_buffer: [5]u8 = undefined;
    while (true) {
        if (try reader.readUntilDelimiterOrEof(&input_buffer, '\n')) |line| {
            const trimmed_line = std.mem.trimRight(u8, line, "\r\n");
            const number = try std.fmt.parseUnsigned(u16, trimmed_line, 10);
            if (number > previous) num_increases += 1;
            previous = number;
        } else {
            break;
        }
    }

    const time: u64 = timer.read();

    std.debug.print("{}\n", .{num_increases});
    std.debug.print("time: {}", .{time});
}
