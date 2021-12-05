const std = @import("std");
const List = std.ArrayList;

const util = @import("util.zig");
const gpa = util.gpa;

const tokenize = std.mem.tokenize;
const parseInt = std.fmt.parseInt;
const print = std.debug.print;
const assert = std.debug.assert;

const data = @embedFile("../data/day03.txt");
const inputType = u12;
const inputBits = @typeInfo(inputType).Int.bits;
const inputCounterType = std.math.Log2IntCeil(inputType);

const machineType = enum {
    Oxygen,
    CO2,
};

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

    // Sort the list
    std.sort.sort(inputType, inputList.items, {}, comptime std.sort.desc(inputType));

    // Part 1
    var gammaCounter: [12]usize = [_]usize{0} ** 12;
    var gammaThreshold = inputList.items.len / 2;
    for (inputList.items) |input| {
        var i: inputCounterType = 0;
        while (i < inputBits) : (i += 1) {
            gammaCounter[i] += (input >> i) & 1;
        }
    }

    var gamma: inputType = 0;
    var i: inputCounterType = 0;
    while (i < inputBits) : (i += 1) {
        if (gammaCounter[i] >= gammaThreshold) {
            gamma = gamma | (@as(inputType, 1) << i);
        }
    }
    assert(gamma == 1337);
    const result = @as(u32, gamma) * @as(u32, ~gamma);
    print("Gamma {} Epsilon {} Result {}\n", .{ gamma, ~gamma, result });

    // Part 2
    var oxygenOutput = findValue(inputList.items, .Oxygen);
    assert(oxygenOutput == 1599);
    print("Oxygen {}\n", .{oxygenOutput});

    var co2Output = findValue(inputList.items, .CO2);
    assert(co2Output == 2756);
    print("CO2 {}\n", .{co2Output});

    var lifeSupport = @as(u32, oxygenOutput) * @as(u32, co2Output);
    print("Life Support {}\n", .{lifeSupport});
    assert(lifeSupport == 4406844);
}

fn findInputSplit(input: []inputType, bit: inputCounterType) ?usize {
    var mask = (@as(inputType, 1) << bit);
    for (input) |item, index| {
        if ((item & mask) != mask) {
            return index;
        }
    }

    return null;
}

fn findValue(input: []inputType, machine: machineType) inputType {
    var i: inputCounterType = inputBits;
    var items: []inputType = input[0..];
    while (i > 0) {
        i -= 1;
        if (items.len == 1) {
            return items[0];
        }

        var threshold = (items.len + 1) / 2;
        var index = findInputSplit(items, i) orelse continue;

        if (index >= threshold) {
            if (machine == .Oxygen) {
                items = items[0..index];
            } else {
                items = items[index..];
            }
        } else {
            if (machine == .Oxygen) {
                items = items[index..];
            } else {
                items = items[0..index];
            }
        }
    }

    assert(items.len == 1);

    return items[0];
}
