const std = @import("std");
const c_net = @cImport({
    @cInclude("net.h");
});
const net = std.net;

const print = std.debug.print;

pub fn initServer() !net.Server {
    var ip = std.mem.span(c_net.getLocalNetworkAddress(@constCast("en0")));
    if (std.mem.eql(u8, ip, "0.0.0.0")) {
        ip = std.mem.span(c_net.getLocalNetworkAddress(@constCast("eth0")));
    }

    if (std.mem.eql(u8, ip, "0.0.0.0")) {
        @panic("Local Network Address Not Found");
    }

    print("Local Network Test Address: {s}\n", .{ip});

    const address = try net.Ip4Address.parse(ip, 53982);
    const localhost = net.Address{ .in = address };
    var server = try localhost.listen(.{});

    const addr = server.listen_address.getPort();
    print("TCP Running on {s}:{d}\n", .{ ip, addr });

    return server;
}

pub fn handleConnection(client: *net.Server.Connection, allocator: std.mem.Allocator) !void {
    const message = try client.stream.reader().readAllAlloc(allocator, 1024);
    defer allocator.free(message);

    print("Request: {s}\n", .{message});

    try client.stream.writer().writeAll(message);
}
