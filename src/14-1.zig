const std = @import("std");
const print = std.debug.print;
const file = @embedFile("../input/14.txt");

const HashMap = std.StringHashMap(usize);
const FnMap = std.StringHashMap(Thingy);

const Thingy = struct {
    pair: []const u8,
    wedge: []const u8,

    const Self = @This();
    pub fn do(self: *Self, counts: *HashMap, totals: *HashMap, count: usize) void {
        totals.getPtr(self.wedge).?.* += count;
        if (counts.getPtr(self.pair)) |counts_ptr| {
            counts_ptr.* -= count;
        }
        if (counts.getPtr(&.{ self.pair[0], self.wedge[0] })) |counts_ptr| {
            counts_ptr.* += count;
        }
        if (counts.getPtr(&.{ self.wedge[0], self.pair[1] })) |counts_ptr| {
            counts_ptr.* += count;
        }
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var counts = HashMap.init(&gpa.allocator);
    var map = FnMap.init(&gpa.allocator);
    var totals = HashMap.init(&gpa.allocator);

    var it = std.mem.tokenize(u8, file, "\r\n");

    const input = it.next().?;

    // Count up input pairs
    var i: usize = 0;
    while (i < input.len - 1) : (i += 1) {
        if (counts.getPtr(input[i .. i + 2])) |counts_ptr| {
            counts_ptr.* += 1;
        } else {
            try counts.putNoClobber(input[i .. i + 2], 1);
        }

        if (totals.getPtr(input[i .. i+1])) |totals_ptr| {
            totals_ptr.* += 1;
        } else {
            try totals.putNoClobber(input[i .. i + 1], 1);
        }
    }
    if (totals.getPtr(input[i .. i+1])) |totals_ptr| {
        totals_ptr.* += 1;
    } else {
        try totals.putNoClobber(input[i .. i + 1], 1);
    }


    // Build mapping thingy
    while (it.next()) |line| {
        var line_it = std.mem.tokenize(u8, line, " -> ");
        const left = line_it.next().?;
        const t = Thingy{ .pair = left, .wedge = line_it.next().? };
        try map.putNoClobber(left, t);

        if (counts.get(left)) |_| {} else {
            try counts.put(left, 0);
        }

        // Fill up our totals map
        if (totals.getPtr(left[0..1])) |_| {} else {
            try totals.put(left[0..1], 0);
        }

        if (totals.getPtr(left[1..2])) |_| {} else {
            try totals.put(left[1..2], 0);
        }
    }

    // Run the steps
    var step: usize = 0;
    while (step < 40) : (step += 1) {
        var key_it = counts.keyIterator();
        var clone = try counts.clone();
        while (key_it.next()) |key| {
            const counts_value = clone.get(key.*).?;
            if (counts_value == 0) continue;


            if (map.getPtr(key.*)) |map_thingy| {
                map_thingy.*.do(&counts, &totals, counts_value);
            }
        }
        //counts = clone;
    }

    // Find the highest value
    var key_it = totals.keyIterator();
    var largest: usize = 0;
    var smallest: usize = 99999999999999;
    var largestKey: []const u8 = "";
    var smallestKey: []const u8 = "";
    while (key_it.next()) |key| {
        const value = totals.get(key.*).?;
        if (value > largest) {
            largest = value;
            largestKey = key.*;
        }

        if (value < smallest) {
            smallest = value;
            smallestKey = key.*;
        }
    }

    print("largest: {s} {}\n", .{ largestKey, largest });
    print("smallest: {s} {}\n", .{ smallestKey, smallest });
    print("result: {}", .{largest - smallest});
    //print("length: {}\n", .{length});
}
