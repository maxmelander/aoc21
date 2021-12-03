const std = @import("std");
const print = std.debug.print;
const file = @embedFile("../input/03.txt");

pub fn main() !void {
    const timer = try std.time.Timer.start();
    var it = std.mem.tokenize(u8, file, "\n");

    // Count bits
    var bit_counts: [12]usize = .{0} ** 12;
    while (it.next()) |line| {
        const number = try std.fmt.parseUnsigned(u12, line, 2);
        var bit_index: u4 = 0;
        while (bit_index < 12) : (bit_index += 1) {
            const bit = (number >> (bit_index)) & 1;
            bit_counts[bit_index] += 1 * bit;
        }
    }

    // Set correct bits and calc result
    var gamma: u64 = 0;
    var epsilon: u64 = 0;
    var result: u64 = 0;
    var i: u4 = 0;
    for (bit_counts) |count| {
        const gamma_bit: u12 = if (count > 500) 0 else 1;
        const epsilon_bit: u12 = if (count > 500) 1 else 0;
        gamma |= (gamma_bit << i);
        epsilon |= (epsilon_bit << i);
        i += 1;
    }
    result = gamma * epsilon;

    const time: u64 = timer.read();
    std.debug.print("time: {}\n", .{time});
    print("result: {}\n", .{result});
}
