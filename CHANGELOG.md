# Unlock CN GMS

## Changelog

## v4.1
- 不支持自动挂载的将尝试使用 [mountify standalone](https://github.com/backslashxx/mountify/blob/standalone-script/global_mount.sh) 挂载，如果都不支持则使用原版的处理方式<br>Try to use [mountify standalone](https://github.com/backslashxx/mountify/blob/standalone-script/global_mount.sh) when the path is not supported whiteout.

## v4.0
- Use whiteout in Magisk 28102+, KernelSU and APatch when path supported.