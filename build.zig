const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const zlib_dep = b.dependency("zlib", .{
        .target = target,
        .optimize = optimize,
    });

    const zstd_dependency = b.dependency("zstd", .{
        .target = target,
        .optimize = optimize,
    });

    const bzip_dep = b.dependency("bzip2", .{
        .target = target,
        .optimize = optimize,
    });

    const upstream = b.dependency("upstream", .{});

    const lib_mod = b.createModule(.{
        .target = target,
        .optimize = optimize,
    });
    lib_mod.link_libc = true;
    lib_mod.linkLibrary(zlib_dep.artifact("z"));
    lib_mod.linkLibrary(bzip_dep.artifact("bz"));
    lib_mod.linkLibrary(zstd_dependency.artifact("zstd"));

    lib_mod.addCSourceFiles(.{
        .root = upstream.path("lib"),
        .files = &.{
            "zip_add.c",
            "zip_add_dir.c",
            "zip_add_entry.c",
            "zip_algorithm_bzip2.c",
            "zip_algorithm_deflate.c",
            // "zip_algorithm_xz.c", // TODO
            "zip_algorithm_zstd.c",
            "zip_buffer.c",
            "zip_close.c",
            // "zip_crypto_commoncrypto.c", // TODO
            // "zip_crypto_gnutls.c", // TODO
            // "zip_crypto_mbedtls.c", // TODO
            // "zip_crypto_openssl.c", // TODO
            // "zip_crypto_win.c", // TODO
            "zip_delete.c",
            "zip_dir_add.c",
            "zip_dirent.c",
            "zip_discard.c",
            "zip_entry.c",
            "zip_error.c",
            "zip_error_clear.c",
            "zip_error_get.c",
            "zip_error_get_sys_type.c",
            "zip_error_strerror.c",
            "zip_error_to_str.c",
            "zip_extra_field.c",
            "zip_extra_field_api.c",
            "zip_fclose.c",
            "zip_fdopen.c",
            "zip_file_add.c",
            "zip_file_error_clear.c",
            "zip_file_error_get.c",
            "zip_file_get_comment.c",
            "zip_file_get_external_attributes.c",
            "zip_file_get_offset.c",
            "zip_file_rename.c",
            "zip_file_replace.c",
            "zip_file_set_comment.c",
            "zip_file_set_encryption.c",
            "zip_file_set_external_attributes.c",
            "zip_file_set_mtime.c",
            "zip_file_strerror.c",
            "zip_fopen.c",
            "zip_fopen_encrypted.c",
            "zip_fopen_index.c",
            "zip_fopen_index_encrypted.c",
            "zip_fread.c",
            "zip_fseek.c",
            "zip_ftell.c",
            "zip_get_archive_comment.c",
            "zip_get_archive_flag.c",
            "zip_get_encryption_implementation.c",
            "zip_get_file_comment.c",
            "zip_get_name.c",
            "zip_get_num_entries.c",
            "zip_get_num_files.c",
            "zip_hash.c",
            "zip_io_util.c",
            "zip_libzip_version.c",
            "zip_memdup.c",
            "zip_name_locate.c",
            "zip_new.c",
            "zip_open.c",
            "zip_pkware.c",
            "zip_progress.c",
            "zip_rename.c",
            "zip_replace.c",
            "zip_set_archive_comment.c",
            "zip_set_archive_flag.c",
            "zip_set_default_password.c",
            "zip_set_file_comment.c",
            "zip_set_file_compression.c",
            "zip_set_name.c",
            "zip_source_accept_empty.c",
            "zip_source_begin_write.c",
            "zip_source_begin_write_cloning.c",
            "zip_source_buffer.c",
            "zip_source_call.c",
            "zip_source_close.c",
            "zip_source_commit_write.c",
            "zip_source_compress.c",
            "zip_source_crc.c",
            "zip_source_error.c",
            "zip_source_file_common.c",
            "zip_source_file_stdio.c",
            "zip_source_free.c",
            "zip_source_function.c",
            "zip_source_get_dostime.c",
            "zip_source_get_file_attributes.c",
            "zip_source_is_deleted.c",
            "zip_source_layered.c",
            "zip_source_open.c",
            "zip_source_pass_to_lower_layer.c",
            "zip_source_pkware_decode.c",
            "zip_source_pkware_encode.c",
            "zip_source_read.c",
            "zip_source_remove.c",
            "zip_source_rollback_write.c",
            "zip_source_seek.c",
            "zip_source_seek_write.c",
            "zip_source_stat.c",
            "zip_source_supports.c",
            "zip_source_tell.c",
            "zip_source_tell_write.c",
            "zip_source_window.c",
            "zip_source_write.c",
            "zip_source_zip.c",
            "zip_source_zip_new.c",
            "zip_stat.c",
            "zip_stat_index.c",
            "zip_stat_init.c",
            "zip_strerror.c",
            "zip_string.c",
            "zip_unchange.c",
            "zip_unchange_all.c",
            "zip_unchange_archive.c",
            "zip_unchange_data.c",
            "zip_utf-8.c",
        },
        .flags = &.{
            "-DZIP_STATIC",
        },
    });

    // "zip_winzip_aes.c",
    // "zip_source_winzip_aes_decode.c",
    // "zip_source_winzip_aes_encode.c",

    if (target.result.os.tag == .windows) {
        lib_mod.addCSourceFiles(.{
            .root = upstream.path("lib"),
            .files = &.{
                "zip_random_win32.c",
                "zip_source_file_win32.c",
                "zip_source_file_win32_ansi.c",
                "zip_source_file_win32_named.c",
                "zip_source_file_win32_utf8.c",
                "zip_source_file_win32_utf16.c",
                // "zip_random_uwp.c", // TODO
            },
        });
    } else {
        lib_mod.addCSourceFiles(.{
            .root = upstream.path("lib"),
            .files = &.{
                "zip_random_unix.c",
                "zip_source_file_stdio_named.c",
            },
        });
    }
    lib_mod.addIncludePath(upstream.path("lib"));

    // TODO: generate this at build time
    lib_mod.addCSourceFile(.{
        .file = b.path("src/zip_err_str.c"),
    });

    const config_header = b.addConfigHeader(
        .{ .style = .{ .cmake = upstream.path("config.h.in") } },
        .{
            .ENABLE_FDOPEN = true,
            .HAVE___PROGNAME = true,
            .HAVE__CLOSE = true,
            .HAVE__DUP = true,
            .HAVE__FDOPEN = true,
            .HAVE__FILENO = true,
            .HAVE__FSEEKI64 = true,
            .HAVE__FSTAT64 = true,
            .HAVE__SETMODE = true,
            .HAVE__SNPRINTF = true,
            .HAVE__SNPRINTF_S = target.result.os.tag == .windows,
            .HAVE__SNWPRINTF_S = target.result.os.tag == .windows,
            .HAVE__STAT64 = true,
            .HAVE__STRDUP = true,
            .HAVE__STRICMP = true,
            .HAVE__STRTOI64 = true,
            .HAVE__STRTOUI64 = true,
            .HAVE__UNLINK = true,
            .HAVE_ARC4RANDOM = target.result.abi == .gnu,
            .HAVE_CLONEFILE = false,
            .HAVE_COMMONCRYPTO = true,
            .HAVE_CRYPTO = false, // TODO
            .HAVE_FICLONERANGE = target.result.os.tag == .linux,
            .HAVE_FILENO = true,
            .HAVE_FCHMOD = true,
            .HAVE_FSEEKO = true,
            .HAVE_FTELLO = true,
            .HAVE_GETPROGNAME = true,
            .HAVE_GNUTLS = true,
            .HAVE_LIBBZ2 = true,
            .HAVE_LIBLZMA = false, // TODO
            .HAVE_LIBZSTD = true,
            .HAVE_LOCALTIME_R = true,
            .HAVE_LOCALTIME_S = target.result.os.tag == .windows,
            .HAVE_MEMCPY_S = target.result.os.tag == .windows,
            .HAVE_MBEDTLS = true,
            .HAVE_MKSTEMP = true,
            .HAVE_NULLABLE = true,
            .HAVE_OPENSSL = true,
            .HAVE_SETMODE = false,
            .HAVE_SNPRINTF = true,
            .HAVE_SNPRINTF_S = false,
            .HAVE_STRCASECMP = true,
            .HAVE_STRDUP = true,
            .HAVE_STRERROR_S = false, //target.result.os.tag == .windows,
            .HAVE_STRERRORLEN_S = target.result.os.tag == .windows,
            .HAVE_STRICMP = true,
            .HAVE_STRNCPY_S = target.result.os.tag == .windows,
            .HAVE_STRTOLL = true,
            .HAVE_STRTOULL = true,
            .HAVE_STRUCT_TM_TM_ZONE = true,
            .HAVE_STDBOOL_H = true,
            .HAVE_STRINGS_H = true,
            .HAVE_UNISTD_H = target.result.os.tag != .windows,
            .HAVE_WINDOWS_CRYPTO = false,
            .SIZEOF_OFF_T = 8, // TODO
            .SIZEOF_SIZE_T = 8, // TODO
            .HAVE_DIRENT_H = true,
            .HAVE_FTS_H = true,
            .HAVE_NDIR_H = true,
            .HAVE_SYS_DIR_H = target.result.os.tag != .windows,
            .HAVE_SYS_NDIR_H = target.result.os.tag != .windows,
            .WORDS_BIGENDIAN = false,
            .HAVE_SHARED = false,
            .CMAKE_PROJECT_NAME = "libzip",
            .CMAKE_PROJECT_VERSION = "1.11.2",
        },
    );
    lib_mod.addConfigHeader(config_header);

    const zipconf_header = b.addConfigHeader(
        .{ .style = .{ .cmake = upstream.path("zipconf.h.in") } },
        .{
            .ZIP_STATIC = true,
            .libzip_VERSION = "0.11.2",
            .libzip_VERSION_MAJOR = 0,
            .libzip_VERSION_MINOR = 11,
            .libzip_VERSION_PATCH = 2,

            .ZIP_NULLABLE_DEFINES = null,

            .LIBZIP_TYPES_INCLUDE = .@"#include <stdint.h>",

            .ZIP_INT8_T = .int8_t,
            .ZIP_UINT8_T = .uint8_t,
            .ZIP_INT16_T = .int16_t,
            .ZIP_UINT16_T = .uint16_t,
            .ZIP_INT32_T = .int32_t,
            .ZIP_UINT32_T = .uint32_t,
            .ZIP_INT64_T = .int64_t,
            .ZIP_UINT64_T = .uint64_t,
        },
    );
    lib_mod.addConfigHeader(zipconf_header);

    const lib = b.addLibrary(.{
        .linkage = .static,
        .name = "zip",
        .root_module = lib_mod,
    });
    lib.installHeader(upstream.path("lib/zip.h"), "zip.h");
    lib.installConfigHeader(zipconf_header);

    b.installArtifact(lib);
}
