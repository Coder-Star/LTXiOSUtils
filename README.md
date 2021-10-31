# LTXiOSUtil 介绍

![issues](https://img.shields.io/github/issues/Coder-Star/LTXiOSUtils)
![forks](https://img.shields.io/github/forks/Coder-Star/LTXiOSUtils)
![stars](https://img.shields.io/github/stars/Coder-Star/LTXiOSUtils)
![license](https://img.shields.io/github/license/Coder-Star/LTXiOSUtils)
![cocoapods](https://img.shields.io/cocoapods/v/LTXiOSUtils)
[![Doc](https://img.shields.io/badge/doc-https%3A%2F%2Fcoder--star.github.io%2FLTXiOSUtils-lightgrey)](https://coder-star.github.io/LTXiOSUtils/)

## 简介

该项目其实不是解决某一个问题而诞生，而是将一些功能、架构设计融入进去，不断的优化改进，算是一个开发的加速库，并且遵循严格的代码规范，注释完备。

### Core层

#### 扩展
绝大多数扩展使用了`tx`前缀，部分扩展因为语法限制或者使用考虑没有使用前缀。
#### 核心工具类
目前主要包含日志输出以及语法糖两个工具类。

### 工具类

- 日志工具
- 网络请求
- UserDafult 协议

## 关于代码规范
目前代码规范使用的是SwiftFormat工具，然后在Build过程中会调用脚本自动format，同时在git提交前也会通过githook使用SwiftFormat的lint模式校对代码的规范性（防止未build直接commit），注意这个阶段不会自动format。

## Features
- 写demo