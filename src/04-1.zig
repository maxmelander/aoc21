const std = @import("std");
const print = std.debug.print;
const file = @embedFile("../input/04.txt");

const Cell = struct {
    value: u8,
    marked: bool
};

pub const Board = struct {
    data: [5][5] u8 = undefined,
    marks: [5][5] bool = .{.{false} ** 5} ** 5,

    const Self = @This();
    pub fn mark(self: *Self, number: u8) ?usize {
        var row: usize = 0; while (row < 5) : (row += 1) {
            var column: usize = 0; while (column < 5) : (column += 1) {
                if (self.data[row][column] == number) self.marks[row][column] = true;
                if (self.check(row, column)) {
                    return self.getResult(number);
                }
            }
        }
        return null;
    }

    // If we marked a position, we only need to test that
    // row and column for a win
    fn check(self: *Self, row: usize, column: usize) bool {
        return (self.marks[row][0] and self.marks[row][1] and self.marks[row][2] and self.marks[row][3] and self.marks[row][4])
            or (self.marks[0][column] and self.marks[1][column] and self.marks[2][column] and self.marks[3][column] and self.marks[4][column]);
    }

    fn getResult(self: *Self, lucky_number: u8) usize {
        var sum: usize = 0;
        var row: usize = 0; while (row < 5) : (row += 1) {
            var column: usize = 0; while (column < 5) : (column += 1) {
                if (!self.marks[row][column]) {
                    sum += self.data[row][column];
                }
            }
        }
        return sum * lucky_number;
    }
};

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

    // Play bingo
    while (numbers_it.next()) |lucky_number| {
        const ln = try std.fmt.parseUnsigned(u8, lucky_number, 10);
        for (boards) |*b| {
            if (b.mark(ln)) |result| {
                const time: u64 = timer.read();
                print("WE GOT A WINNER! result: {}\n", .{result});
                std.debug.print("time: {}\n", .{time});
                return;
            }
        }
    }

    print("number: {any}\n", .{boards[2].data});
}
