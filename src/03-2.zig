const std = @import("std");
const print = std.debug.print;
const file = @embedFile("../input/03.txt");

fn getDoneIndex(values: *[1000]bool) ?usize {
    var num_true: usize = 0;
    var index: usize = 0;
    for (values) |value, i| {
        if (value) {
            num_true += 1;
            index = i;
        }
        if (num_true > 1) return null;
    }
    return index;
}

fn moreZero(active: [1000]bool, values: [1000]u12, index: u4) bool {
    var num_0: usize = 0;
    var num_1: usize = 0;
    for (values) |value, i| {
        if (active[i]) {
            const bit = (value >> (11 - index)) & 1;
            if (bit == 0) num_0 += 1;
            if (bit == 1) num_1 += 1;
        }
    }
    return num_0 > num_1;
}

pub fn main() !void {
    const timer = try std.time.Timer.start();
    var it = std.mem.tokenize(u8, file, "\n");

    // Put bits in an array
    var values: [1000]u12 = .{0} ** 1000;
    var index: usize = 0;
    while (it.next()) |line| : (index += 1) {
        const number = try std.fmt.parseUnsigned(u12, line, 2);
        values[index] = number;
    }

    // Oxygen generator
    var oxygen_indices: [1000]bool = .{true} ** 1000;
    var oxygen_res: u12 = 0;

    var magma_indices: [1000]bool = .{true} ** 1000;
    var magma_res: u12 = 0;

    // For every bit position, loop through our values and figure shit out
    var bit_index: u4 = 0;
    while (bit_index < 12): (bit_index +=1) {
        const gamma_bit: u12 = if (moreZero(oxygen_indices, values, bit_index)) 0 else 1;
        const magma_bit: u12 = if (moreZero(magma_indices, values, bit_index)) 1 else 0;

        if (oxygen_res == 0) {
         for (oxygen_indices) |o, i| {
            if (o) {
                const value = values[i];
                const bit = (value >> (11 - bit_index)) & 1;

                if (bit != gamma_bit) {
                    oxygen_indices[i] = false;
                }
                if (getDoneIndex(&oxygen_indices)) |done_index| {
                    oxygen_res = values[done_index];
                    break;
                }
            }
        }
        }

        if (magma_res == 0) {
         for (magma_indices) |o, i| {
            if (o) {
                const value = values[i];
                const bit = (value >> (11 - bit_index)) & 1;
                if (bit != magma_bit) {
                    magma_indices[i] = false;
                }
                if (getDoneIndex(&magma_indices)) |done_index| {
                    magma_res = values[done_index];
                    break;
                }
            }
        }
        }
        if (magma_res != 0 and oxygen_res != 0) {
            const time: u64 = timer.read();
            std.debug.print("time: {}\n", .{time});
            print("Done {} {}\n", .{oxygen_res, magma_res});
            return;
        }
    }
}
