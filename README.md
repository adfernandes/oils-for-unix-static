# What is this?

_**TODO Describe what this is...**_

The `musl`-based `gcc` cross compiler is from [here](https://github.com/adfernandes/musl-cross-make).

**Note** that the compilers are:

* built from the `make-all` branch that adds a `make-all.sh` script
* to the `gcc-15.2-support` branch, that adds support for `gcc 15.2`.

Due to GitHub free-usage limits, the `musl-cross-make.tgz` archive is **not** included here.

For reference, **at the time of this writing**, the specific configuration is:

```
BINUTILS_VER = 2.44
GCC_VER = 15.2.0
GMP_VER = 6.3.0
LINUX_VER = 5.8.5
MPC_VER = 1.3.1
MPFR_VER = 4.2.2
MUSL_VER = 1.2.5
```

and the supported targets are:

```
aarch64_be-linux-musl
aarch64-linux-musl
armeb-linux-musleabi
armeb-linux-musleabihf
arm-linux-musleabi
arm-linux-musleabihf
mipsel-linux-musl
mipsel-linux-muslsf
mips-linux-musl
mips-linux-muslsf
x86_64-linux-musl
```
