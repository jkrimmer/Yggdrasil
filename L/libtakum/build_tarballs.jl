# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder, Pkg

name = "libtakum"
version = v"0.1.1"

# Collection of sources required to complete build
sources = [
    GitSource("https://github.com/takum-arithmetic/libtakum.git", "fd1f336b5ec21c689d4d9777be29ea4119d151bf")
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/libtakum
./configure
make PREFIX=${prefix} LDCONFIG= -j${nproc} install
rm -f ${prefix}/lib/libtakum.a ${prefix}/lib/libtakum.lib
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms()

# The products that we will ensure are always built
products = [
    LibraryProduct("libtakum", :libtakum)
]

# Dependencies that must be installed before this package can be built
dependencies = Dependency[
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies; julia_compat="1.6")
