const std = @import("std");
const print = std.debug.print;
const file = @embedFile("../input/11.txt");

const GRID_WIDTH = 12;

var num_blasts: usize = 0;
var step_blasts: usize = 0;

const Octopus = struct {
    energy: u8,
    x: usize,
    y: usize,

    pub fn blastOff(self: *Octopus, grid: *[GRID_WIDTH * GRID_WIDTH]?Octopus) void {
        step_blasts += 1;
        num_blasts += 1;

        self.energy = 0;
        var n_x: usize = self.x - 1;
        while (n_x <= self.x + 1) : (n_x += 1) {
            var n_y: usize = self.y - 1;
            while (n_y <= self.y + 1) : (n_y += 1) {
                if (n_x == self.x and n_y == self.y) continue;
                const i: usize = n_x + GRID_WIDTH * n_y;
                if (grid[i]) |*n| {
                    if (n.energy > 0) {
                        n.increaseEnergy(grid);
                    }
                }
            }
        }
    }

    pub fn increaseEnergy(self: *Octopus, grid: *[GRID_WIDTH * GRID_WIDTH]?Octopus) void {
        self.energy += 1;
        if (self.energy > 9) {
            self.blastOff(grid);
        }
    }
};

pub fn main() !void {
    var octos: [GRID_WIDTH * GRID_WIDTH]?Octopus = .{null} ** (GRID_WIDTH * GRID_WIDTH);

    var it = std.mem.tokenize(u8, file, "\n\r");
    var x: usize = 1;
    while (it.next()) |line| : (x += 1) {
        for (line) |c, y| {
            const i: usize = x + (GRID_WIDTH * (y + 1));
            const parsed = try std.fmt.parseUnsigned(u8, &.{c}, 10);
            const octopus = Octopus{
                .energy = parsed,
                .x = x,
                .y = y + 1,
            };
            octos[i] = octopus;
        }
    }

    var step: usize = 0;
    while (true) : (step += 1) {
        step_blasts = 0;
        for (octos) |*oct| {
            if (oct.*) |*o| o.energy += 1;
        }

        for (octos) |*oct| {
            if (oct.*) |*o| {
                if (o.energy > 9) {
                    o.blastOff(&octos);
                }
            }
        }
        if (step == 99) {
            print("part 1: {}\n", .{num_blasts});
        }
        if (step_blasts == 100) {
            print("part 2: {}\n", .{step + 1});
            break;
        }
    }
}
