const std = @import("std");
const cnet = @cImport({
    @cInclude("net.h");
});
const net = std.net;

const print = std.debug.print;

pub fn initServer() !net.Server {
    const ip = std.mem.span(cnet.getLocalNetworkAddress(@constCast("en0")));
    if (std.mem.eql(u8, ip, "0.0.0.0")) {
        @panic("Unable to get Local Network Test Address");
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
