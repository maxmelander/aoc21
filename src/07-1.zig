const std = @import("std");
const print = std.debug.print;
const file = @embedFile("../input/07-test.txt");

// const INPUT_SIZE = 1000;
const INPUT_SIZE = 10;
//
fn cmpByValue(context: void, a: u16, b: u16) bool {
    return std.sort.asc(i32)(context, a, b);
}

pub fn main() !void {
    var it = std.mem.tokenize(u8, file, ",\r\n");
    var list: [INPUT_SIZE]u16 = undefined;
    var i: usize = 0;
    while (it.next()) |val| : (i += 1) {
        const num = try std.fmt.parseUnsigned(u16, val, 10);
        list[i] = num;
    }

    std.sort.sort(u16, list[0..], {}, cmpByValue);

    var last_count: usize = 0;
    var mode: usize = 0;
    var current_num: usize = 0;
    for (list) |num| {}
    //var sum: usize = 0;
    //for (list) |crab| {
    //sum += crab;
    //}
    //const average: f32 = @intToFloat(f32, sum) / @intToFloat(f32, INPUT_SIZE);
    //const r: usize = @floatToInt(usize, std.math.round(average));
    //std.sort.sort(u16, list[0..], {}, cmpByValue);
    //const median = list[INPUT_SIZE / 2];
    //print("av {}\n", .{r});

    // Calc fuel cost
    var res: usize = 9999999999;
    var target: usize = 0;
    while (target < 2000) : (target += 1) {
        var fuel_cost: usize = 0;
        for (list) |lol| {
            const dist = @intCast(i32, target) - @intCast(i32, lol);
            const absDist = @intCast(usize, try std.math.absInt(dist));

            var s: usize = 0;
            var idx: usize = 1;
            while (idx <= absDist) : (idx += 1) s += idx;

            fuel_cost += s;
        }

        if (fuel_cost < res) res = fuel_cost;
    }

    print("fuel {}\n", .{res});
}
