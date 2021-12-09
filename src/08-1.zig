const std = @import("std");
const print = std.debug.print;
const file = @embedFile("../input/08.txt");

const ONE = 2;
const FOUR = 4;
const SEVEN = 3;
const EIGHT = 7;

const Mapping = struct {
    zero: []const u8 = undefined,
    one: []const u8 = undefined,
    two: []const u8 = undefined,
    three: []const u8 = undefined,
    four: []const u8 = undefined,
    five: []const u8 = undefined,
    six: []const u8 = undefined,
    seven: []const u8 = undefined,
    eight: []const u8 = undefined,
    nine: []const u8 = undefined,
};

fn eql(a: []const u8, b: []const u8) bool {
    if (a.len != b.len) return false;

    for (a) |a_c| {
        if (std.mem.indexOfScalar(u8, b, a_c)) |_| {} else {
            return false;
        }
    }
    return true;
}
fn numIn(input: []const u8, mapping: []const u8) usize {
    var res: usize = 0;
    for (mapping) |c| {
        if (std.mem.indexOfScalar(u8, input, c)) |_| {
            res += 1;
        }
    }
    return res;
}

pub fn main() !void {
    var it = std.mem.tokenize(u8, file, "\n");

    var res: usize = 0;
    while (it.next()) |line| {
        var mapping = Mapping{};

        var line_it = std.mem.tokenize(u8, line, "|");
        var input = std.mem.tokenize(u8, line_it.next().?, " ");
        var output = std.mem.tokenize(u8, line_it.next().?, " ");
        _ = output;

        var inputs: [10][]const u8 = .{""} ** 10;

        var in: usize = 0; while (input.next()) |i| : (in += 1) {
             inputs[in] = i;
             switch(i.len) {
                ONE => mapping.one = i,
                FOUR => mapping.four = i,
                SEVEN => mapping.seven = i,
                EIGHT => mapping.eight = i,
                else => {}
            }
        }

        // decode
        for (inputs) |i| {
            if (i.len == ONE or i.len == FOUR or i.len == SEVEN or i.len == EIGHT) continue;
            var s: usize = numIn(i, mapping.seven);
            var o: usize = numIn(i, mapping.one);
            var f: usize = numIn(i, mapping.four);
            var e: usize = numIn(i, mapping.eight);

            if (s == 2 and o == 1 and f == 3 and e == 5) {
                mapping.five = i;
                continue;
            }

            if (s == 2 and o == 1 and f == 2 and e == 5) {
                mapping.two = i;
                continue;
            }

            if (s == 3 and o == 2 and f == 3 and e == 5) {
                mapping.three = i;
                continue;
            }

            if (s == 3 and o == 2 and f == 4 and e == 6) {
                mapping.nine = i;
                continue;
            }

            if (s == 2 and o == 1 and f == 3 and e == 6) {
                mapping.six = i;
                continue;
            }

            if (s == 3 and o == 2 and f == 3 and e == 6) {
                mapping.zero = i;
                continue;
            }
        }

        var place: usize = 4;
        var num: usize = 0;
        while (output.next()) |o| : (place -= 1) {
            if (eql(o, mapping.zero)) continue;
            var val: usize = 0;
            if (eql(o, mapping.one)) {val = 1;}
            else if (eql(o, mapping.two)) {val = 2;}
            else if (eql(o, mapping.three)) {val = 3;}
            else if (eql(o, mapping.four)) {val = 4;}
            else if (eql(o, mapping.five)) {val = 5;}
            else if (eql(o, mapping.six)) {val = 6;}
            else if (eql(o, mapping.seven)) {val = 7;}
            else if (eql(o, mapping.eight)) {val = 8;}
            else if (eql(o, mapping.nine)) {val = 9;}
            num += val * (std.math.pow(usize , 10, place - 1));
        }
        res += num;
    }
    print("res: {}", .{res});
}
