// Zig Imports
const std = @import("std");
const mem = std.mem;
const os = std.os;

// C Imports
const cProc = @cImport(@cInclude("proc.h"));
const cMem = @cImport(@cInclude("memory.h"));

// Assembly Imports
extern fn getStackPointer() usize;
extern fn addNumbers(a: i32, b: i32) i32;

// Errors
const MemoryError = error{ReadAtAddressError};

// Structs
const procMem = struct {
    addr: []const u8,
    perms: []const u8,
    offset: []const u8,
    dev: []const u8,
    inode: []const u8,
};

fn readAtAddress(address: usize) u8 {
    std.debug.print("Reading at address: {x}\n", .{address});
    // return @as(*u8, @ptrFromInt(address)).*;
    return 0;
}

fn getPid() i32 {
    switch (@import("builtin").os.tag) {
        .linux => return @intCast(os.linux.getpid()),
        .macos => return cProc.c_getPid(),
        .windows => return @intCast(os.windows.GetCurrentProcessId()),
        else => return "Unsupported OS",
    }
}

pub fn copyMem() !?procMem {
    std.debug.print("PID: {d}\n", .{getPid()});
    std.debug.print("SP: {x}\n", .{getStackPointer()});

    std.debug.print("First Memory Address Value: {x}:{d}\n", .{ readAtAddress(getStackPointer()), readAtAddress(getStackPointer()) });

    return null;
}
