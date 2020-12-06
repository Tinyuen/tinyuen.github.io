---
title: 手动实现 jsonp 解决跨域问题
date: 2018-05-23 20:06:00
from: 原创
categories:
- web前端
tags:
- JavaScript
---

前端跨域是一个老生常谈的话题，解决跨域的方式有很多种，`jsonp` 就是其中的一种。今天就来简单实现一个 `jsonp`
<!-- more -->

## 何为跨域
通俗易懂的说，跨域就是一个域下面的脚本去请求另一个域下面的资源，就成为跨域。不过这种说法是比较广义的说法。

平时前端开发中所说的跨域，一般指的是由浏览器的一种安全策略 —— “同源策略” 所导致的。

## 同源策略
**同源策略**是一个重要的安全策略，它用于限制一个origin的文档或者它加载的脚本如何能与另一个源的资源进行交互。它能帮助阻隔恶意文档，减少可能被攻击的媒介。
如果两个 URL 的 protocol、port (如果有指定的话)和 host 都相同的话，则这两个 URL 是同源。这个方案也被称为“协议/主机/端口元组”，或者直接是 “元组”。（“元组” 是指一组项目构成的整体，双重/三重/四重/五重/等的通用形式）。

## 常见的解决跨域的方法
在前端的开发中，跨域应该是最司空见惯的问题。解决跨域其实方法有很多种，常用的方法有：
* 通过jsonp跨域
* document.domain + iframe跨域
* postMessage跨域
* nginx代理跨域
* nodejs中间件代理跨域

等等...

## jsonp 跨域方案
从上面可以知道，其实实际开发中解决跨域的方案有很多种。不过我们这次只介绍 `jsonp` 这种方案。
直接上代码：

```javascript
(function(window, document) {
  "use strict";
  var jsonp = function(url, data, callback) {
    var dataString = url.indexof("?") === -1 ? "?" : "&";

    for (var key in data) {
      dataString += key + "=" + data[key] + "&";
    }

    var cbFuncName = "my_json_cb_" + Math.random().toString().replace(".", "");
    dataString += "callback=" + cbFuncName;

    var scriptEle = document.createElement("script");
    scriptEle.src = url + dataString;

    window[cbFuncName] = function(data) {
      callback(data);
      document.body.removeChild(scriptEle);
    };

    document.body.appendChild(scriptEle);
  };

  window.$jsonp = jsonp;
})(window, document);
```

上面的代码没有使用目前流行的ES6语法，目的是方便使用。不过目前开发都是使用babel编译的，可以自行将代码转换为ES6语法，这样看起来更舒服一点。