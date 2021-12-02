const std = @import("std");

pub fn ParserIterator(comptime buffer_size: usize, comptime delimiter: u8) type {
    return struct {
        buffer: [buffer_size]u8 = undefined,
        reader: std.io.BufferedReader(4096, std.fs.File.Reader),
        delimiter: u8 = delimiter,
        file: std.fs.File,

        const Self = @This();
        pub fn init(file_name: []const u8) !Self {
            const file = try std.fs.cwd().openFile(file_name, .{ .read = true });
            return Self{ .reader = std.io.bufferedReader(file.reader()), .file = file };
        }

        pub fn next(self: *Self) !?[]const u8 {
            if (try self.reader.reader().readUntilDelimiterOrEof(&self.buffer, self.delimiter)) |line| {
                return std.mem.trimRight(u8, line, "\r\n");
            } else {
                return null;
            }
        }

        pub fn close(self: *Self) void {
            self.file.close();
        }
    };
}
