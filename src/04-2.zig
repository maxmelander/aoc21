const std = @import("std");
const print = std.debug.print;
const file = @embedFile("../input/04.txt");
const Board = @import("04-1.zig").Board;

pub fn main() !void {
    const timer = try std.time.Timer.start();
    var it = std.mem.tokenize(u8, file, "\n");

    // Our bingo numbers are accessible through this iterator
    var numbers_it = std.mem.tokenize(u8, it.next().?, ",");

    var boards: [100]Board = undefined;

    // Fill the boards
    var board: usize = 0; while (board < 100 )  : (board += 1) {
        var row: usize = 0; while (row < 5) : (row += 1) {
            var column_it = std.mem.tokenize(u8, it.next().?, " ");
            var column_i: usize = 0;
            while (column_it.next()) |column| : (column_i += 1) {
                const number = try std.fmt.parseUnsigned(u8, column, 10);
                boards[board].data[row][column_i] = number;
            }
        }
    }

    var active_boards: [100]bool = .{true} ** 100;
    var boards_left: usize = 100;
    // Play bingo
    while (numbers_it.next()) |lucky_number| {
        const ln = try std.fmt.parseUnsigned(u8, lucky_number, 10);
        for (boards) |*b, i| {
            if (active_boards[i]) {
                if (b.mark(ln)) |result| {
                    active_boards[i] = false;
                    boards_left -= 1;
                    if (boards_left == 0) {
                        const time: u64 = timer.read();
                        print("WE GOT THE LAST WINNER! result: {}\n", .{result});
                        std.debug.print("time: {}\n", .{time});
                        return;
                    }
                }
            }
        }
    }

    print("number: {any}\n", .{boards[2].data});
}
