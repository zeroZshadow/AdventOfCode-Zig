const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Str = []const u8;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("../data/day03.txt");
const inputType = u12;

pub fn main() !void {
    // Parse input
    var inputList: List(inputType) = List(inputType).init(gpa);
    defer inputList.deinit();
    var it = std.mem.tokenize(u8, data, "\n");
    while (it.next()) |line| {
        if (line.len == 0) continue;
        const input = try parseInt(inputType, line, 2);
        try inputList.append(input);
    }
    assert(inputList.items[0] == 2093);

    // Part 1 gamma
    var gammaCounter: [12]usize = [_]usize{0} ** 12;
    var gammaThreshold = inputList.items.len / 2;
    for (inputList.items) |input| {
        var i: u4 = 0;
        while (i< @typeInfo(inputType).Int.bits) : (i+=1) {
            gammaCounter[i] += (input >> i) & 1;
        }
    }

    var gamma: inputType = 0;
    var i: u4 = 0;
    while (i < @typeInfo(inputType).Int.bits) : (i+=1) {
        if (gammaCounter[i] >= gammaThreshold){
            gamma = gamma | (@as(inputType, 1) << i);
        }
    }
    assert(gamma == 1337);
    const result = @as(u32, gamma) * @as(u32, ~gamma);
    print("Gamma {} Epsilon {} Result {}\n", .{gamma, ~gamma, result});
}

// Useful stdlib functions
const tokenize = std.mem.tokenize;
const split = std.mem.split;
const indexOf = std.mem.indexOfScalar;
const indexOfAny = std.mem.indexOfAny;
const indexOfStr = std.mem.indexOfPosLinear;
const lastIndexOf = std.mem.lastIndexOfScalar;
const lastIndexOfAny = std.mem.lastIndexOfAny;
const lastIndexOfStr = std.mem.lastIndexOfLinear;
const trim = std.mem.trim;
const sliceMin = std.mem.min;
const sliceMax = std.mem.max;

const parseInt = std.fmt.parseInt;
const parseFloat = std.fmt.parseFloat;

const min = std.math.min;
const min3 = std.math.min3;
const max = std.math.max;
const max3 = std.math.max3;

const print = std.debug.print;
const assert = std.debug.assert;

const sort = std.sort.sort;
const asc = std.sort.asc;
const desc = std.sort.desc;
