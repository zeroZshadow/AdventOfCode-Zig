const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const parseInt = std.fmt.parseInt;
const tokenize = std.mem.tokenize;
const split = std.mem.split;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("../data/day02.txt");

pub fn main() !void {
    var instructions = std.ArrayList(Instruction).init(gpa);
    defer instructions.deinit();

    // Parse input into instruction list
    var lineIterator = std.mem.tokenize(u8, data, "\n");
    while (lineIterator.next()) |line| {
        if (line.len == 0) continue;
        var parts = std.mem.split(u8, line, " ");
        const command = parts.next().?;
        const distance = try parseInt(u32, parts.next().?, 10);

        const instruction = Instruction{ .direction = switch (command[0]) {
            'f' => .Forward,
            'u' => .Up,
            'd' => .Down,
            else => unreachable,
        }, .distance = distance };

        try instructions.append(instruction);
    }

    // Act on instructions
    var submarine = Submarine.init();
    for (instructions.items) |inst| {
        switch (inst.direction) {
            .Forward => submarine.MoveForward(inst.distance),
            .Up => submarine.MoveUp(inst.distance),
            .Down => submarine.MoveDown(inst.distance),
        }
    }

    // Part1
    const resultPart1 = submarine.aim * submarine.distance;
    std.debug.assert(resultPart1 == 2187380);
    std.debug.print("Submarine value1 {}\n", .{resultPart1});

    // Part 2
    const resultPart2 = submarine.depth * submarine.distance;
    std.debug.assert(result == 2086357770);
    std.debug.print("Submarine value2 {}\n", .{resultPart2});
}

const Direction = enum { Forward, Down, Up };

const Instruction = struct { direction: Direction, distance: usize };

const Submarine = struct {
    const Self = @This();

    distance: usize = 0,
    depth: usize = 0,
    aim: usize = 0,

    pub fn init() Submarine {
        return Submarine{
            .distance = 0,
            .depth = 0,
            .aim = 0,
        };
    }

    pub fn MoveForward(this: *Self, distance: usize) void {
        this.distance += distance;
        this.depth += this.aim * distance;
    }

    pub fn MoveUp(this: *Self, distance: usize) void {
        this.aim -= distance;
    }

    pub fn MoveDown(this: *Self, distance: usize) void {
        this.aim += distance;
    }
};
