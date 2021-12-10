const std = @import("std");
const print = std.debug.print;
const file = @embedFile("../input/10.txt");

pub fn main() !void {
    var it = std.mem.tokenize(u8, file, "\n");

    var stack: [150]u8 = .{'.'} ** 150;
    var i: usize = 0;
    var score: usize = 0;
    while (it.next()) |line| : (i += 1) {
        var stack_marker: usize = 0;
        for (line) |c| {
            switch (c) {
                '(' => {
                    stack[stack_marker] = ')';
                    stack_marker += 1;
                },
                '[' => {
                    stack[stack_marker] = ']';
                    stack_marker += 1;
                },
                '{' => {
                    stack[stack_marker] = '}';
                    stack_marker += 1;
                },
                '<' => {
                    stack[stack_marker] = '>';
                    stack_marker += 1;
                },
                '\r' => {}, // Annoying boy right here
                else => {
                    stack_marker -= 1;
                    if (stack[stack_marker] != c) {
                        switch (c) {
                            ')' => score += 3,
                            ']' => score += 57,
                            '}' => score += 1197,
                            '>' => score += 25137,
                            else => {},
                        }
                        break;
                    }
                },
            }
        }
    }
    print("score: {}\n", .{score});
}
