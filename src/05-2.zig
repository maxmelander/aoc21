const std = @import("std");
const print = std.debug.print;
const file = @embedFile("../input/05.txt");

const Cell = struct{
    value: usize = 0,
    counted: bool = false,
};
var board: [1000][1000]Cell = .{.{Cell{}} ** 1000} ** 1000;

pub fn main() !void {
    const timer = try std.time.Timer.start();
    var it = std.mem.tokenize(u8, file, "\n");

    var result: usize = 0;
    while (it.next()) |line| {
        // Input parsing
        var line_it = std.mem.tokenize(u8, line, " -> ");
        const start = line_it.next().?;
        const end = line_it.next().?;

        var start_it = std.mem.tokenize(u8, start, ",");
        var end_it = std.mem.tokenize(u8, end, ",");

        const start_x = try std.fmt.parseUnsigned(i32, start_it.next().?, 10);
        const start_y = try std.fmt.parseUnsigned(i32, start_it.next().?, 10);
        const end_x = try std.fmt.parseUnsigned(i32, end_it.next().?, 10);
        const end_y = try std.fmt.parseUnsigned(i32, end_it.next().?, 10);

        // Problem solving
        const distx: i32 = end_x - start_x;
        const disty: i32 = end_y - start_y;
        var signx: i32 = 1;
        if (distx < 0) signx = -1;
        var signy: i32 = 1;
        if (disty < 0) signy = -1;

        if (start_x == end_x) {
            var i:i32 = 0; while(i <= disty * signy) : (i+=1) {
                const x = @intCast(usize, start_x);
                const y = @intCast(usize, start_y+(i*signy));
                const v = &board[x][y];
                if (!v.counted) {
                    v.value += 1;
                    if (v.value > 1) {
                        v.counted = true;
                        result += 1;
                    }
                }
            }
        } else if (start_y == end_y) {
            var i:i32 = 0; while(i <= distx * signx) : (i+=1) {
                const x: usize = @intCast(usize, start_x+(i*signx));
                const y = @intCast(usize, start_y);
                const v = &board[x][y];
                if (!v.counted) {
                    v.value += 1;
                    if (v.value > 1) {
                        v.counted = true;
                        result += 1;
                    }
                }
            }
        } else if (start_x != end_x and start_y != end_y) {
            var i:i32 = 0; while(i <= distx * signx) : (i+=1) {
                const ix: usize = @intCast(usize, start_x+(i*signx));
                const iy: usize = @intCast(usize, start_y+(i*signy));
                const v = &board[ix][iy];
                if (!v.counted) {
                    v.value += 1;
                    if(v.value > 1) {
                        v.counted = true;
                        result += 1;
                    }
                }
            }
        }
    }

    const time: u64 = timer.read();
    print("result {}\n", .{result});
    std.debug.print("time: {}\n", .{time});
}
