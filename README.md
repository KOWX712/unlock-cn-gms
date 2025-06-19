# Unlock CN GMS

> [!NOTE]
> 此版本使用 Magisk v28102 新特性，抹除 permissions 文件,支持 APatch/KernelSU。
> 
> 使用体验与原版无异。
> 
> 不支持自动挂载的将尝试使用 [mountify standalone](https://github.com/backslashxx/mountify/blob/standalone-script/global_mount.sh) 挂载，如果都不支持则使用原版的处理方式

The GMS is restricted in China on some devices, because of a configuration file located in `/system/etc/permissions/services.cn.google.xml`.
by this restriction, you can not enable `Google Location History` and the `Google Map Timeline` function can not use either.

This module removes the restriction by replacing this configuration file.

---
部分国行手机，或者本地化后的 ROM 中有内置 GMS ，但是某些功能无法使用，比如无法开启 `Google Location History` 服务，无法使用 `Google Map Timeline`，设备无法在 Web 版 Google play 中显示等等。

该模块通过替换 `/system/etc/permissions/services.cn.google.xml` 文件, 具体为删除如下配置行：

 ```xml
 <feature name="cn.google.services" />
 <feature name="com.google.android.feature.services_updater" />
 ``` 
 以此来实现去除国行 GMS 的限制。

 **注意**：为了开启 `Google Location History` 服务，你可能还需要配合其他模块   
 例如
 Magisk 模块: ~~[Riru - Location Report Enabler](https://github.com/RikkaApps/Riru-LocationReportEnabler)~~     
 或者 Xposed 模块 [LocationReportEnabler](https://github.com/GhostFlying/LocationReportEnabler)
