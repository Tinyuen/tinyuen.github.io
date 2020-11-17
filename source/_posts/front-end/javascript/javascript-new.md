---
title: 在 JavaScript 中 new 发生了什么？
date: 2017-07-11 23:13:00
from: 原创
categories:
- web前端
tags:
- JavaScript
---

我们知道，在 JavaScript 中可以通过 new 操作符来实例化一个对象。那么，在JavaScript的底层，new 做了什么事情呢？
<!-- more -->

## new 发生了什么
1. 首先创建了一个对象。
2. 构造该对象的 `_proto_` 属性。
3. 将构造函数的上下文 `this` 指向该对象，并执行构造函数。
4. 返回新对象

## 简单实现一个 `new`
```javascript
function myNew() {
    // 创建对象
    let obj = Object.create();
    // 获得传入的构造函数，取arguments剩余参数作为参数。
    let Con = Array.prototype.shift.call(arguments);
    // 绑定对象的proto
    obj._proto_ = Con.prototype;
    // 调用构造函数，指定this为obj
    let result = Con.apply(obj, arguments);
    // 返回新对象
    return result instanceof Object ? result : obj;
}

// 测试
function Person(name, age) {
    this.name = name;
    this.age = age;
}
// 使用内置的new
const person = new Person('Toy', 18);
// 使用我们自己的方法
const person2 = myNew(Person, 'Toy', 18);
```

以上。