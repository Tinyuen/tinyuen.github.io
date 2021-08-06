---
title: Javascript 中实现位数字添加千分位
date: 2019-06-11 20:30:00
from: 原创
categories:
- web前端
tags:
- JavaScript
---

今天聊一个比较有意思的问题，就是在 JavaScript 中为数字添加千分位。这种在一些需要显示金额的地方可能会用到。今天我们来探索几种不同的方法。

<!-- more -->

# 解法一：toLocaleString()
我们先看一种比较简单的方法，代码行数最少。numObj.toLocaleString([locales [, options]])
```javascript
const num = 1234567;
const str = num.toLocaleString()
console.log(str) // 1,234,567
```

不过需要注意的是，使用前需要先关注下各个浏览器的兼容性情况。

## 解法二：正则

正则是我个人比较喜欢的一种方式，代码量少并且执行效率较高。

```javascript
const num = '10000000000';
const result = num.replace(/\d{1,3}(?=(\d{3})+$)/g, '$&,');
console.log(result); // 10,000,000,000
```
不过上面的这种正则不支持数字里面带小数点。如果带有小数点的可能需要额外处理下。

```javascript
const num = '12345678.01';
const [left, right] = num.split('.');
const result = `${left.replace(/\d{1,3}(?=(\d{3})+$)/g, '$&,')}.${right}`;
console.log(result); // 12,345,678.01
```

## 解法三：for 循环

通过循环的方式，自然是最符合程序猿思维的方式了。不过相比较上面的两种方式代码量就比较多了。

```typescript
function format(num) {
  let numStr = `${num}`;
  let str = '';
  for(let i = numStr.length - 1, j = 1; i >= 0; i--, j++){
    if(j%3 === 0 && i !== 0){
      str += `${numStr[i]},`;
      continue;
    }
    str += numStr[i];
  }
  return str.split('').reverse().join('');
}
```

## 解法四：reduce 版本
```typescript
function format(num) {
  let numStr = `${num}`;
  return numStr.split('').reverse().reduce((prev, next, index) => {
    return ((index % 3) ? next : `${next},`) + prev;
  })
}
```

哈哈  just for fun!