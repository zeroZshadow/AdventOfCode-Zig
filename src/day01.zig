const std = @import("std");
const util = @import("util.zig");

const gpa = util.gpa;
const parseInt = std.fmt.parseInt;
const print = std.debug.print;
const assert = std.debug.assert;

const data = @embedFile("../data/day01.txt");

pub fn main() !void {
    // Parse input into depthList
    comptime var depthList: []const u32 = &[_]u32{};
    comptime {
        @setEvalBranchQuota(10000000);
        var it = std.mem.tokenize(u8, data, "\n");
        while (it.next()) |line| {
            if (line.len == 0) continue;
            const depth = try parseInt(u32, line, 10);
            depthList = depthList ++ [_]u32{depth};
        }
    }

    // Part 1
    const increases = comptime calculateDepthChanges(1, depthList);
    const result1 = comptime std.fmt.comptimePrint("There are {} depth increases\n", .{increases});
    print(result1, .{});

    // Part 2
    const increases_ranges = comptime calculateDepthChanges(3, depthList);
    const result2 = comptime std.fmt.comptimePrint("There are {} depth range increases\n", .{increases_ranges});
    print(result2, .{});
}

fn calculateDepthChanges(comptime windowSize: u32, items: []const u32) u32 {
    var increases: u32 = 0;
    var last_depth = sum(windowSize, items[0..]);

    var i: u32 = 0;
    while (i <= items.len - windowSize) : (i += 1) {
        var depth = sum(windowSize, items[i..]);
        if (depth > last_depth) {
            increases += 1;
        }

        last_depth = depth;
    }

    return increases;
}

fn sum(comptime windowSize: u32, items: []const u32) u32 {
    assert(items.len >= windowSize);

    var total: u32 = 0;
    comptime var i: u32 = 0;
    inline while (i < windowSize) : (i += 1) {
        total += items[i];
    }

    return total;
}
