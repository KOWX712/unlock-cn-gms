# Unlock CN GMS

## Changelog

## v4.4
- 修复在非 真我 等 my_heytap 设备下同样会执行相关逻辑的问题 (fei-ke#27)
- 在安装了 mountify 的情况下将交由 mountify 来挂载。
- 更新 [mountify standalone](https://github.com/backslashxx/mountify/commit/019a216866fae4ffc0c65adcf9a98228dc67a87d)

## v4.3
- 修复flyme11模块下多一层system的问题

## v4.2
- 新增 ColorOS 15.0.1 支持<br>Add support for ColorOS 15.0.1

## v4.1
- 不支持自动挂载的将尝试使用 [mountify standalone](https://github.com/backslashxx/mountify/blob/standalone-script/global_mount.sh) 挂载，如果都不支持则使用原版的处理方式<br>Try to use [mountify standalone](https://github.com/backslashxx/mountify/blob/standalone-script/global_mount.sh) when the path is not supported whiteout.

## v4.0
- Use whiteout in Magisk 28102+, KernelSU and APatch when path supported.