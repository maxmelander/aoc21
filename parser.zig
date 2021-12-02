const std = @import("std");

pub fn ParserIterator(comptime buffer_size: usize, comptime delimiter: u8) type {
    return struct {
        buffer: [buffer_size]u8 = undefined,
        reader: std.io.BufferedReader(4096, std.fs.File.Reader),
        delimiter: u8 = delimiter,

        const Self = @This();
        pub fn init(file: std.fs.File) Self {
            return .{
                .reader = std.io.bufferedReader(file.reader()),
            };
        }

        pub fn next(self: *Self) !?[]const u8 {
            if (try self.reader.reader().readUntilDelimiterOrEof(&self.buffer, self.delimiter)) |line| {
                return std.mem.trimRight(u8, line, "\r\n");
            } else {
                return null;
            }
        }
    };
}
