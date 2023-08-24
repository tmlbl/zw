const std = @import("std");

pub fn matches(path: []const u8, glob: []const u8) bool {
    var i_p = path.len;
    var i_g = glob.len;

    while (i_p > 0 and i_g > 0) {
        const g = glob[i_g - 1];
        const p = path[i_p - 1];

        //std.debug.print("{c} {d} {c} {d}\n", .{ g, i_g, p, i_p });

        switch (g) {
            '*' => {
                if (p == '/') {
                    i_g -= 1;
                    if (i_g == 0) {
                        return false;
                    }
                }

                if (i_g > 1) {
                    const peek = glob[i_g - 2];
                    if (p == peek) {
                        i_g -= 1;
                        continue;
                    }
                }

                i_p -= 1;
                continue;
            },
            else => {
                if (g != p) {
                    return false;
                } else {
                    i_g -= 1;
                    if (i_g == 0 and i_p > 1) {
                        return false;
                    }
                }
            },
        }
        i_p -= 1;
    }

    return true;
}

test "glob" {
    try std.testing.expect(matches("main.zig", "*.zig"));
    try std.testing.expect(!matches("main.go", "*.zig"));
    try std.testing.expect(!matches("src/main.zig", "*.zig"));
    try std.testing.expect(matches("go.mod", "go.*"));
    try std.testing.expect(!matches("shego.md", "go.*"));
    try std.testing.expect(!matches("build.zig", "src/*.zig"));
}
