const std = @import("std");
const c_net = @cImport({
    @cInclude("net.h");
});
const net = std.net;

const print = std.debug.print;

pub fn initServer(interfaceOverride: [*c]const u8) !net.Server {
    const _defaultInterface: [*:0]const u8 = "en0";

    const interfaceOverrideSlice: []const u8 = interfaceOverride[0..std.mem.len(interfaceOverride)];

    var _interfaceOverride: [*:0]const u8 = undefined;

    if (std.mem.eql(u8, interfaceOverrideSlice, "")) {
        _interfaceOverride = _defaultInterface;
    } else {
        _interfaceOverride = interfaceOverride;
    }

    var ip = std.mem.span(c_net.getLocalNetworkAddress(@constCast(_interfaceOverride)));
    if (std.mem.eql(u8, ip, "0.0.0.0")) {
        _interfaceOverride = "eth0";
        ip = std.mem.span(c_net.getLocalNetworkAddress(@constCast(_interfaceOverride)));
    }

    if (std.mem.eql(u8, ip, "0.0.0.0")) {
        // @panic("Local Network Address Not Found");
        std.debug.print("Unable to interface with local area network\n", .{});
        std.debug.print("Defaulting to localhost\n", .{});

        ip = @constCast("127.0.0.1");
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
