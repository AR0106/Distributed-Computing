const std = @import("std");
const net = std.net;
const print = std.debug.print;

const tcp = @import("./server/tcp.zig");
const procClient = @import("./client/memory.zig");

pub fn main() !void {
    // Only MacOS and Linux are Currently Supported
    if (@import("builtin").os.tag != .linux and @import("builtin").os.tag != .macos) @panic("Unsupported OS");

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    _ = try procClient.copyMem();

    var server = tcp.initServer() catch |err| {
        print("{s}", .{@errorName(err)});
        @panic("Failed to Start Server");
    };
    defer server.deinit();

    while (true) {
        const acceptResult = server.accept();
        if (acceptResult) |client| {
            defer client.stream.close();
            tcp.handleConnection(@constCast(&client), allocator) catch |err| {
                print("{!}", .{err});
                continue;
            };
        } else |err| {
            switch (err) {
                error.ConnectionAborted => {
                    std.debug.print("Connection Aborted\n", .{});
                    continue;
                },
                else => {
                    std.debug.print("Accept error: {!}\n", .{err});
                    if (@errorReturnTrace()) |trace| {
                        std.debug.dumpStackTrace(trace.*);
                    }
                    break;
                },
            }
        }
    }
}
