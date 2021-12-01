const std = @import("std");
const Vector = std.meta.Vector;

pub fn main() !void {
    var input_buffer: [12000]u8 = undefined;
    var input_numbers: [2000]u16 = undefined;

    const timer = try std.time.Timer.start();
    const file = try std.fs.cwd().openFile("01-input1.txt", .{ .read = true });
    defer file.close();

    // Reading the whole file first, then parsing
    // aka my own buffered reader kinda thing
    _ = try file.reader().readAll(&input_buffer);
    var index: usize = 0;
    var iterator = std.mem.split(u8, &input_buffer, "\n");

    while (iterator.next()) |line| {
        const trimmed_line = std.mem.trimRight(u8, line, "\r\n");
        const number = std.fmt.parseUnsigned(u16, trimmed_line, 10) catch break;
        input_numbers[index] = number;
        index += 1;
    }

    var num_increases: usize = 0;
    var i: usize = 0;
    while (i + 3 < 2000) : (i += 1) {
        const a = input_numbers[i] + input_numbers[i + 1] + input_numbers[i + 2];
        const b = input_numbers[i + 1] + input_numbers[i + 2] + input_numbers[i + 3];

        if (b > a) num_increases += 1;
    }

    const time: u64 = timer.read();

    std.debug.print("num increases: {} \n", .{num_increases});
    std.debug.print("time: {}", .{time});
}
