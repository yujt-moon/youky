# youky

## 操作系统

## 软件安装
### bochs 安装

> 说明此处使用的 bochs 的命令是通过 Ubuntu 的 `apt-get install` 安装的（不是项目自带的）
```shell
bximage -q -hd=16 -func=create -sectsize=512 -imgmode=flat $(BUILD)/master.img
```
