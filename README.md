[![CI](https://github.com/allyourcodebase/libzip/actions/workflows/ci.yaml/badge.svg)](https://github.com/allyourcodebase/libzip/actions)

# libzip

This is [libzip](https://github.com/winlibs/libzip/), packaged for [Zig](https://ziglang.org/).

## Installation

First, update your `build.zig.zon`:

```
# Initialize a `zig build` project if you haven't already
zig init
zig fetch --save git+https://github.com/allyourcodebase/libzip.git#1.11.2
```

You can then import `libzip` in your `build.zig` with:

```zig
const bzip_dependency = b.dependency("libzip", .{
    .target = target,
    .optimize = optimize,
});
your_exe.linkLibrary(bzip_dependency.artifact("zip"));
```
## Notes
Crypto and LZMA are not supported right now.
