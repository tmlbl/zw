const std = @import("std");

const Action = struct {};

pub fn main() !void {
    var args = std.process.args();
    _ = args.skip();
    var allocator = std.heap.page_allocator;

    var files = std.ArrayList([]const u8).init(allocator);
    defer files.deinit();

    var in_capture_files = false;
    while (args.next()) |arg| {
        std.debug.print("argument: {s}\n", .{arg});

        if (std.mem.startsWith(u8, arg, "--")) {
            in_capture_files = false;
        }

        if (in_capture_files) {
            var buf = try allocator.alloc(u8, arg.len);
            @memcpy(buf, arg);
            try files.append(buf);
            continue;
        }

        if (std.mem.eql(u8, arg, "--files")) {
            in_capture_files = true;
            continue;
        }
    }

    var watcher = try std.fs.Watch(Action).init(allocator, files.items.len);
    for (files.items) |path| {
        try watcher.addFile(path, Action{});
    }
}
