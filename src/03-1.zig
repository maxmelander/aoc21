const std = @import("std");
const print = std.debug.print;
const file = @embedFile("../input/03.txt");

const Counter = struct {
    num_0: usize = 0,
    num_1: usize = 0
};

pub fn main() !void {
    const timer = try std.time.Timer.start();
    var it = std.mem.tokenize(u8, file, "\n");

    // Count bits
    var arr: [12]Counter = .{Counter{}} ** 12;
    while (it.next()) |line| {
        const number = try std.fmt.parseUnsigned(u12, line, 2);
        var bit_index: u4 = 0;
        while (bit_index < 12) : (bit_index += 1) {
            const bit = (number >> (bit_index)) & 1;
            if (bit == 0) {
                arr[bit_index].num_0 += 1;
            } else {
                arr[bit_index].num_1 += 1;
            }
        }
    }

    // Set correct bits and calc result
    var gamma: u64 = 0;
    var epsilon: u64 = 0;
    var result: u64 = 0;
    var i: u4 = 0;
    for (arr) |count| {
        const gamma_bit: u12 = if (count.num_0 > count.num_1) 0 else 1;
        const epsilon_bit: u12 = if (count.num_0 > count.num_1) 1 else 0;
        gamma |= (gamma_bit << i);
        epsilon |= (epsilon_bit << i);
        i += 1;
    }
    result = gamma * epsilon;

    const time: u64 = timer.read();
    std.debug.print("time: {}\n", .{time});
    print("result: {}\n", .{result});
}
