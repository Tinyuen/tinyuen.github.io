---
title: IOS ( Safari ) 返回页面不刷新如何解决？
date: 2017-04-11 22:39:00
from: 原创
categories:
- web前端
tags:
- JavaScript
---

在平时开发移动端项目的时候，是否被`IOS`或者部分`Android`浏览器返回页面不刷新的问题困扰过？这个问题应该比较常见的一个问题。
<!-- more -->
比如一个典型的场景：页面未登录，点击页面某个按钮后跳转公共的登录页面完成登录后，点击浏览器返回按钮。返回到上个页面，发现页面直接从缓存读取，并没有刷新，导致最新的登录态无法获得。当然了，如果是单页应用，登录页面是前端的`router`
自然是没这个问题了。

如果是非单页，通过`location.href`的方式跳走再返回这种情况该如何处理呢？

## PageTransitionEvent.persisted
那既然是因为读取了缓存导致，如果可以判断是不是走了缓存，岂不是就能解决问题？答案是可行的！

`PageTransitionEvent` 的只读属性 `persisted` 代表一个页面是否从缓存中加载的。

```javascript
window.addEventListener('pageshow', function(event) {
  if (event.persisted) {
    console.log('Page was loaded from cache.');
  }
});
```

## 解决方案
在页面展示的时候判断是不是走了缓存，如果是，那就重新刷新页面。代码如下：

```javascript
const browserRule = /^.*((iPhone)|(iPad)|(Safari))+.*$/;
if (browserRule.test(navigator.userAgent)) {
    window.addEventListener('pageshow', function(event) {
        if (event.persisted) {
            window.location.reload();
        }
    });
}
```

基本上大部分情况都是IOS才会有这个问题，注意判断下设备是IOS设备再添加此代码。