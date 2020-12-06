---
title: 实现 Promise finally
date: 2017-09-11 19:42:00
from: 原创
categories:
- web前端
tags:
- JavaScript
---

给 `Promise` 实现 `finally` 方法
<!-- more -->

废话不多说，比较简单，直接上代码吧

```javascript
Promise.prototype.finally = function (callback) {
  let P = this.constructor;
  return this.then(
    value => P.resolve(callback()).then(() => value),
    reason => P.resolve(callback()).then(() => { throw reason })
  );
};
```