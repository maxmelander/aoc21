const std = @import("std");
const print = std.debug.print;
const file = @embedFile("../input/09.txt");

var grid: [102][102]u8 = .{.{9} ** 102} ** 102;

fn basin(found:*[102][102]bool, x: usize, y:usize) usize {
    const current = grid[x][y];
    found[x][y] = true;

    var res: usize = 1;

    const left = grid[x - 1][y];
    const right = grid[x + 1][y];

    const up = grid[x][y+1];
    const down = grid[x][y-1];

    if (left > current and left != 9 and !found[x-1][y]) {
        res += basin(found, x-1, y);
    }

    if (right > current  and right != 9 and !found[x+1][y]) {
        res += basin(found, x+1, y);
    }

    if (up > current and up != 9 and !found[x][y+1]) {
        res += basin(found, x, y+1);
    }

    if (down > current and down != 9 and !found[x][y-1]) {
        res += basin(found, x, y-1);
    }

    return res;
}

pub fn main() !void {
    var it = std.mem.tokenize(u8, file, "\n");

    var x: usize = 1;
    while (it.next()) |line| : (x += 1) {
        var y: usize = 1;
        for (line) |c| {
            const num = try std.fmt.parseUnsigned(u8, &.{c}, 10);
            grid[y][x] = num;
            y += 1;
        }
    }

    x = 1;
    var bs: [3]usize = .{0} ** 3;
    while (x < 101) : (x += 1) {
        var y: usize = 1;
        while (y < 101) : (y += 1) {
            const current = grid[x][y];
            if (
                current < grid[x - 1][y] and
                current < grid[x + 1][y] and
                current < grid[x][y-1] and
                current < grid[x][y+1]
            ) {
                // Find its basin or whatever
                var found:[102][102]bool = .{.{false}**102} ** 102;
                const basin_value = basin(&found, x, y);
                for (bs) |b, i| {
                    if (basin_value > b) {
                        bs[i] = basin_value;
                        break;
                    }
                }
            }
        }
    }

    var result: usize = bs[0] * bs[1] * bs[2];
    print("result: {}\n", .{result});
    print("bs: {any}\n", .{bs});
}
