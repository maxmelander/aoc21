const std = @import("std");
const print = std.debug.print;
const file = @embedFile("../input/10.txt");

pub fn main() !void {
    var it = std.mem.tokenize(u8, file, "\n");

    var stack: [150]u8 = .{'.'} ** 150;
    var i: usize = 0;
    var score_index: usize = 0;
    var autocomplete_scores: [55]usize = .{0} ** 55;
    line_label: while (it.next()) |line| : (i += 1) {
        var stack_marker: usize = 0;
        for (line) |c, c_index| {
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
                        continue :line_label;
                    }
                },
            }

            // If we've reached the end of the line
            // roll back the stack and count our scores
            if (c_index == line.len - 1) {
                var line_score: usize = 0;
                stack_marker -= 1;
                while (stack_marker >= 0) : (stack_marker -= 1) {
                    line_score *= 5;
                    switch (stack[stack_marker]) {
                        ')' => line_score += 1,
                        ']' => line_score += 2,
                        '}' => line_score += 3,
                        '>' => line_score += 4,
                        else => unreachable,
                    }
                    if (stack_marker == 0) break;
                }

                autocomplete_scores[score_index] = line_score;
                score_index += 1;
            }
        }
    }

    std.sort.sort(usize, autocomplete_scores[0..], {}, cmpByValue);
    print("res: {any}\n", .{autocomplete_scores[27]});
}

fn cmpByValue(context: void, a: usize, b: usize) bool {
    return std.sort.asc(usize)(context, a, b);
}
