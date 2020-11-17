---
title: JavaScript 中 this 的绑定规则
date: 2018-06-27 21:08:00
from: 原创
categories:
- web前端
tags:
- JavaScript
---

javascript 中的 `this` 有时候是比较魔幻的一个存在，在 JavaScript 中 this 有几种常见的绑定方式，今天就来详细的介绍一下。
<!-- more -->

## 默认绑定
默认绑定 this 指向全局对象，但是在严格模式下，即：‘use strict’ ，this 会被绑定成 undefined。

## 隐式绑定
当函数引用有上下文对象时，隐式绑定规则会把函数中的 this 绑定到这个上下文对象。
```javascript
function foo() {
    console.log(this.a);
}

var obj = {
    a: 2,
    foo: foo
};

obj.foo(); // 2
```
参数传递就是一种隐式赋值，传入函数时也会被隐式赋值。

## 显示绑定
很多函数提供了可选参数，来制定上下文。比如 Array 的 forEach 方法 `arr.forEach(fun, context)`，context 指定了函数 fun 的上下文对象。通过 call、apply 或者 bind 这些函数，可以显示的指定函数的上下文环境。

注意：把 `null `或者 `undefined` 作为 this 的绑定对象传入 call、apply 或者 bind，这些值在调用时会被忽略。

call 和 apply 的区别在于，`call` 方法接受的是若干个参数的列表，而 `apply` 方法接受的是一个包含多个参数的数组。

call apply 的使用方法举例:
```javascript
// 判断数组： 
Object.prototype.toString.call(obj) === '[object Array]';

// 数组最大值:
var numbers = [5, 458 , 120 , -215 ]; 
Math.max.apply(null, numbers);   //458   
``` 

### 实现 call(ctx, arg1, arg2 ...)
简单版本：
```javascript
Function.prototype.myCall = function(context) {
    // 此时环境中 context就是目标上下文，this就是原来的函数
    context.fn = this; 		// foo.fn = bar
    context.fn();			// foo.fn()
    delete context.fn;		// delete foo.fn
};

// 测试一下
var foo = { value: 1 };
function bar() {
    console.log(this.value);
}
bar.myCall(foo);  // 1
```

复杂版本：
```javascript
Function.prototype.myCall2 = function (context) {
  context = context ? Object(context) : window; 
  context.fn = this;

  let args = [...arguments].slice(1);
  let result = context.fn(...args);

  delete context.fn;
  return result;
}
```

### 实现 apply(ctx, [arg1, arg2 ...])
```javascript
Function.prototype.apply = function (context, arr) {
    context = context ? Object(context) : window; 
    context.fn = this;
  
    let result;
    if (!arr) {
        result = context.fn();
    } else {
        result = context.fn(...arr);
    }
      
    delete context.fn;
    return result;
}
```

## new 绑定
还有一种 this 的绑定方式就是通过 `new` 操作符。new 会将构造函数的this指向该对象。

## 箭头函数绑定
最后一种就是在箭头函数中的绑定。箭头函数 this 绑定有以下特点：

1. 箭头函数不绑定 this，箭头函数中的 this 相当于普通变量。
2. 箭头函数的this寻值行为与普通变量相同，在作用域中逐级寻找。
3. 箭头函数的this无法通过bind，call，apply来直接修改（可以间接修改）。
4. 改变作用域中this的指向可以改变当前作用域中的箭头函数的this。