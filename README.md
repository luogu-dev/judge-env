# 洛谷评测环境

为了确定化、标准化洛谷评测环境部署，洛谷使用了 Nix Flake 来描述评测机环境。安装完 Nix 后，在当前目录下可使用 `nix flake show` 查看所有环境，输出结果看起来应该像这样：

```
# nix flake show
packages
└───x86_64-linux
    ├───checker: package 'ljudge-env_checker'
    ├───gcc: package 'ljudge-env_gcc'
    ├───gcc-930: package 'ljudge-env_gcc-930'
    ├───ghc: package 'ljudge-env_ghc'
    ├───…………
```

## 进入环境

使用 `nix shell` 可切换进入对应环境（实际是在 PATH 中前置了对应 Nix 包的 bin 目录）。如，切换到 gcc 环境中的 bash，可以使用：

```
nix shell .#gcc -c bash
```

其中 `.#gcc` 代表当前目录（`.`）flake（`#`）的 `gcc` 包。您也可以通过修改 `-c` 参数在环境中执行任意命令。

更多使用方法（如安装到 profile、在自己的 flake 中引用洛谷评测环境的 flake）等，请参考 Nix 的官方文档。

## 二进制缓存加速

为了比赛等情况下的公平，我们限制了 C/C++ 系列语言使用 `pragma` 和 `attribute` 开启 O2 优化的功能，因此对 GCC 进行了[修改](https://github.com/luogu-dev/judge-env/blob/master/gcc/13_disable-pragma-and-attribute-for-optimize.patch)。这就导致 GCC 需要重新编译。

GCC 项目很大，编译很慢、很吃资源。为了加速这一操作，我们将二进制缓存部署在了公开服务 Cachix 上，要使用它，请在执行上面的命令之前运行：

```shell
nix-env -iA cachix -f https://cachix.org/api/v1/install
cachix use luogu-judge
```
