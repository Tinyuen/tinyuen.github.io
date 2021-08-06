---
title: 如何模拟实现 Promise.all
date: 2017-09-17 23:09:46
from: 原创
categories:
- web前端
tags:
- JavaScript
---

在开始之前，我们先看下 Promise.all() 方法的定义。
Promise.all() 方法接收一个 `promise` 的 `iterable` 类型（注：Array，Map，Set都属于ES6的iterable类型）的输入，并且只返回一个Promise实例， 
那个输入的所有promise的resolve回调的结果是一个数组。这个 Promise 的 resolve 回调执行是在所有输入的promise的resolve回调都结束，
或者输入的iterable里没有promise了的时候。它的reject回调执行是，只要任何一个输入的promise的reject回调执行或者输入不合法的promise就会立即抛出错误，并且reject的是第一个抛出的错误信息。

## Promise.all 的使用
```javascript
let promise1 = Promise.resolve(1);
let promise2 = Promise.resolve(2);
let promise3 = Promise.resolve(3);
Promise.all([promise1, promise2, promise3])
  .then(value => {
    console.log(value); // [1, 2, 3]  
  });
```

## 模拟实现一个 Promise.all

从 Promise.all 的定义我们可以知道，Promise.all 具有这样的特点：

* 接收一个 Promise 实例的数组或具有 Iterator 接口的对象，
* 如果元素不是 Promise 对象，则使用 Promise.resolve 转成 Promise 对象
* 如果全部成功，状态变为 resolved，返回值将组成一个数组传给回调
* 只要有一个失败，状态就变为 rejected，返回值将直接传递给回调 all() 的返回值也是新的 Promise 对象

那么我们尝试来实现下：

```javascript
function promiseAll (promises) {
  return new Promise(((resolve, reject) => {
    if (!Array.isArray(promises)) {
      return reject(new TypeError('argument must be an array'));
    }
    let promiseLen = promises.length;
    // 用来接收结果的数组
    let resolveValues = [];
    // 定一个变量记录resolve的promise的数量
    let counter = 0;
    for (let i = 0; i < promiseLen; i++) {
      Promise.resolve(promises[i])
        .then(data => {
          counter++;
          resolveValues[i] = data;
          // 当所有promise resolve后，整个promise resolve
          if (counter === promiseLen) {
            resolve(resolveValues);
          }
        })
        .catch(err => {
          reject(err);
        });
    }
  }));
}
```

以上就是一个较为简单的模拟 Promise.all 的方法。欢迎大家讨论。