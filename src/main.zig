const std = @import("std");
const glob = @import("./glob.zig");

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var args = try std.process.argsAlloc(allocator);
    defer allocator.free(args);

    if (args.len < 2) {
        std.debug.print("usage: doot [glob]", .{});
        return;
    }
    const glopt = args[1];

    std.debug.print("opt: {s}\n", .{glopt});

    const dir = std.fs.cwd();
    const dirname = try dir.realpathAlloc(allocator, ".");
    defer allocator.free(dirname);

    var it = try std.fs.openIterableDirAbsolute(dirname, .{});
    var walker = try it.walk(allocator);
    while (try walker.next()) |entry| {
        std.debug.print("walking {s} {s}\n", .{ entry.path, glopt });
        if (glob.matches(entry.path, glopt)) {
            std.debug.print("MATCH {s} {s}\n", .{ entry.path, glopt });
        }
    }
}
