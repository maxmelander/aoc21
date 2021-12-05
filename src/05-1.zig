const std = @import("std");
const print = std.debug.print;
const file = @embedFile("../input/05.txt");

var board: [1000][1000]usize = .{.{0} ** 1000} ** 1000;

pub fn main() !void {
    var it = std.mem.tokenize(u8, file, "\n");

    while (it.next()) |line| {
        var line_it = std.mem.tokenize(u8, line, " -> ");
        const start = line_it.next().?;
        const end = line_it.next().?;

        var start_it = std.mem.tokenize(u8, start, ",");
        var end_it = std.mem.tokenize(u8, end, ",");
        const start_x = try std.fmt.parseUnsigned(u32, start_it.next().?, 10);
        const start_y = try std.fmt.parseUnsigned(u32, start_it.next().?, 10);

        const end_x = try std.fmt.parseUnsigned(u32, end_it.next().?, 10);
        const end_y = try std.fmt.parseUnsigned(u32, end_it.next().?, 10);

        if (start_x == end_x) {
            if (start_y < end_y) {
                var i:usize = start_y; while(i <= end_y) : (i+=1) {
                    board[start_x][i] += 1;
                }
            } else {
                var i:usize = start_y; while(i >= end_y) : (i-=1) {
                    board[start_x][i] += 1;
                }
            }
        } else if (start_y == end_y) {
            if (start_x < end_x) {
                var i:usize = start_x; while(i <= end_x) : (i+=1) {
                    board[i][start_y] += 1;
                }
            } else {
                 var i:usize = start_x; while(i >= end_x) : (i-=1) {
                    board[i][start_y] += 1;
                }
            }
        }
    }
    var result: usize = 0;
    for (board) |col| {
        for (col) |val| {
            if (val > 1) result += 1;

        }
    }
    print("result {}", .{result});
}
