const std = @import ("std");
const print = std.debug.print;
const file = @embedFile("../input/06.txt");

const ArrayList = std.ArrayList;

const DAYS = 256;

pub fn main() !void {

    var state: [9]u64 = .{0} ** 9;

    var it = std.mem.tokenize(u8, file, ",");
    while (it.next()) |fish| {
        const tf = std.mem.trimRight(u8, fish, "\r\n");
        const v = try std.fmt.parseUnsigned(usize, tf, 10);
        state[v] += 1;
    }

    var i: usize = 0; while (i < DAYS) : (i += 1) {
        std.mem.rotate(u64, state[0..], 1);
        state[6] += state[8];
    }

    var sum: u64 = 0;
    for (state) |v| {
        sum+=v;
    }

    print("res: {}", .{sum});

}
