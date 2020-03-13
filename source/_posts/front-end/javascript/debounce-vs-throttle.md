---
title: debounce
categories:
- web前端
tags:
- JavaScript
---

记录下个人对防抖函数和节流函数的理解，在高频触发的事件中，较为实用。
 <!-- more -->
## _.debounce (func, [wait=0], [options])

创建一个防抖动函数。该函数会在 wait 毫秒后调用 func 方法。该函数提供一个 cancel 方法取消延迟的函数调用以及 flush 方法立即调用。可以提供一个 options 对象决定如何调用 func 方法，options.leading 和 options.trailing 决定延迟前后如何触发。func 会传入最后一次传入的参数给防抖动函数。随后调用的防抖动函数返回是最后一次 func 调用的结果。


个人理解:
* wait = 400, leading = false, trailing = true
函数不会立即执行，当事件连续触发或两次触发间隔小于400ms的时候函数不会执行，直到事件停止触发且隔时间大于400ms，函数执行一次。若间隔时间小于400ms时再次触发事件，则函数执行时间重新开始计算。

* wait = 400, leading = true, trailing = false
函数先立即执行一次，当事件连续触发或两次触发间隔小于400ms的时候函数不会执行，只有当事件停止触发且间隔时间大于400ms时，函数才会变成可执行状态（此时并不会自动自动触发），此时再次触发事件，函数会立即执行一次。
* wait = 400, leading = true, trailing = true
如果都设为true的话，其实效果是相当于两个的结合，函数首先会执行一次，

场景1：页面resize时候，显示窗口大小
场景2：实时动态搜索框

换一种方式实现Debounce
```javascript
    function debounce(fn, wait) {

    }
```


## _.throttle (func, [wait=0], [options])

创建一个节流函数，在 wait 秒内最多执行 func 一次的函数。该函数提供一个 cancel 方法取消延迟函数调用以及 flush 方法立即调用。可以提供一个 options 对象决定如何调用 func 方法，options.leading 和 options.trailing 决定 wait 前后如何触发。func 会传入最后一次传入的参数给这个函数。随后调用的函数返回是最后一次 func 调用的结果。

注意: 如果 leading 和 trailing 都设定为 true。 则 func 允许 trailing 方式调用的条件为: 在 wait 期间多次调用。

相当于是给的bounce方法指定参数： maxWait、leading=true、trailing=true

场景1：页面缩放始终保持弹窗居中显示
场景2：下拉加载

换一种简单的方式实现Throttle
```javascript
    function throttle(fn, wait) {
        var timer = null,
            flag = true
        return function () {
            if(flag) {
                fn.apply(this, arguments)
                flag = false
                timer && clearTimeout(timer)
                timer = setTimeout(() => {
                    flag = true
                }, wait)
            }
        }
    }
```
## 节流和防抖区别

最大的不同，通俗点说就是Debounce的函数可能很久都不会执行一次，但是Throttle的函数则保证了在给定的wait时间内肯定会执行一次，保证了函数的执行。