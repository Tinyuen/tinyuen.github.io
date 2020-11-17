---
title: JavaScript 中的 深拷贝 vs 浅拷贝
date: 2018-03-08 22:12:00
from: 原创
categories:
- web前端
tags:
- JavaScript
---

JavaScript 中的深拷贝与浅拷贝
<!-- more -->

## 数据类型
在讲深拷贝和浅拷贝之前，我们先来重新回顾一下 JavaScript 中的数据类型。 在JavaScript中，数据的类型大体可以分为两类：`基本数据类型` 和 `引用类型`。

### 基本类型
基本数据类型就很好理解了，常见的 `undefined`，`boolean`，`number`，`string`，`null` 等这些都是基本数据类型。
基本类型是存储在内存的 `栈` 中，直接按照值来存放。需要注意的是：基本类型的值是不可改变的。

就拿 `字符串类型` 来说。我们知道在 Java 是一种强类型语言，在 Java 中，`String` 类型是 Public final 修饰的，也就是说是一个不可变类，在Java中字符串一旦创建，就不会在被更改。

虽然 JavaScript 是弱类型的语言，但是在字符串方面还是和 java 保持一致的。在 JavaScript 中，`string` 字符串同样也是不可变的。
```javascript
let lang = "Java";
lang = lang + "Script";
```
如上，虽然 `lang` 被初始赋值成 `Java` 后又重新指向了新的 `JavaScript`，但是在内存中，并不是简单的将 `Java` 字符串修改成 `Javascript`，而是重新创建新的字符串。

### 引用类型
引用类型是存放在内存 `堆` 中。比如常见的 对象、数组、函数都属于引用类型。变量实质上存放的是该对象在 `堆` 中的一个地址。

与基本类型不同的是，引用类型的值是可以改变的，改变的其实也是其在堆内存中的地址值。


## 浅拷贝
浅拷贝就是只复制指向某个对象的指针，而不复制对象本身，新旧对象共享一块内存。
常见的浅拷贝操作有：

Object.assign、展开语法 "..."、Array.prototype.slice 等等。

## 深拷贝
复制并创建一个一摸一样的对象，不共享内存，修改新对象，旧对象保持不变，这称之为深拷贝。

常见的第三方库 `JQuery` `lodash` 都提供有深拷贝的 api。

最简单的实现深拷贝的方法就是利用 JSON.parse
```javascript
JSON.parse(JSON.stringify(obj));
```
不过这种方式有局限：

1. 会忽略 undefined
2. 会忽略 symbol
3. 不能序列化函数
4. 不能解决循环引用的对象
5. 不能正确处理new Date()
6. 不能处理正则

## 简单实现深拷贝
```javascript
function cloneDeep(source) {
    if (!(typeof source === 'object' && source != null)) {
        return source; // 非对象返回自身
    }  
    var target = Array.isArray(source) ? [] : {};
    for(var key in source) {
        if (Object.prototype.hasOwnProperty.call(source, key)) {
            var prop = source[key];
            if (typeof prop === 'object' && prop != null) {
                target[key] = cloneDeep(prop); // 注意这里
            } else {
                target[key] = source[key];
            }
        }
    }
    return target;
}
```

以上。
