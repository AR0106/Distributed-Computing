const std = @import("std");
const mem = std.mem;
const os = std.os;

const cProc = @cImport(@cInclude("proc.h"));

// Assembly Functions
extern fn getStackPointer() usize;
extern fn addNumbers(a: i32, b: i32) i32;

const procMem = struct {
    addr: []const u8,
    perms: []const u8,
    offset: []const u8,
    dev: []const u8,
    inode: []const u8,
};

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

    return null;
}
