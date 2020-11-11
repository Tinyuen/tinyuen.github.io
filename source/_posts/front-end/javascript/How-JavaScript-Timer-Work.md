---
title: javascript 定时器是如何工作的
date: 2019-10-04 20:00:46
type: 原创
categories:
- web前端
tags:
- JavaScript
---

其实说起JavaScript中的定时器(_Timer_)中的 _setTimeout()_ 方法，从事开发的同学想必都不会陌生，觉得这些东西很简单很基础。但是有时候恰恰是基础简单的东西，才越容易被忽略。先看一段代码：
 <!-- more -->
```javascript
console.log('start');

setTimeout(function () {
    console.log('hello');
}, 200);

setTimeout(function () {
    console.log('world');
}, 100);

console.log('end');
```

如果一眼看出了结果，那稍微改动一下，这样呢？

```javascript
console.log('start');

setTimeout(function () {
    console.log('hello');
}, 200);

setTimeout(function () {
    console.log('world');
}, 300);

// 此处仅代表模拟一个耗时运算，这里假设时间大于1秒，
// 便于理解本文的重点，此处不需要过分探究执行时间
for (var i=0;i<10000;i++) {
    console.log(1);
}

setTimeout(function () {
    console.log('I am run');
}, 100);

console.log('end');
```
不通过Console控制台运行，能第一时间知道打印的结果么？如果有点不确定，骚年，继续往下看吧。这段代码仔细研究下其实还是蛮有（keng）趣（die）的。个人认为，这也是Javascript语言相比其他编程语言不严谨的地方。当然，为了能够更好的驾驭Javascript这门神奇的语言，这些东西是必须掌握的。

## JS代码是怎么执行的

那首先应该从JS代码执行说起，JS引擎会在内存中分配堆区（heap）和栈区（stack），那么JS又是以怎样的顺序执行的呢？先看一段很简单的代码：

```javascript
function A() {
    var a = 3;
    B(3);
}
function B(num) {
    var newNum = num * num;
    console.log(newNum);
}
A();
```

当代码运行的时候，为便于理解我们假设栈底有一个main()方法（类似于Java中的入口Main方法）作为运行的开始。

1.代码开始执行

![第1步](http://n1image.hjfile.cn/mh/2016/12/14/797e315861455afca7ba11e13d9cfa1a.png)

2.运行A()方法，将A()入栈，此时A上下文中存在变量 a = 3

![第2步](http://n1image.hjfile.cn/mh/2016/12/14/aefcc296c8a4d0b9f0b8fef7ffd59e13.png)

3.调用B()方法，将B()入栈，此时B上下文中存在变量 num = 3，newNum = 9

![第3步](http://n1image.hjfile.cn/mh/2016/12/14/ad890e7e9f1ddde217319a4cce456b8a.png)

4.调用B()方法中的console.log()，入栈，控制台打印 9

![第4步](http://n1image.hjfile.cn/mh/2016/12/14/69c0a4dcbe95361966a1b3d5aebe3793.png)

5.继续运行，依次将console.log()，和B()方法出栈

![第5步](http://n1image.hjfile.cn/mh/2016/12/14/6b6ec3ba7b90eb0ad2b1a514d2a6e4d5.png)

6.A()方法运行完毕出栈

![第6步](http://n1image.hjfile.cn/mh/2016/12/14/4ea0f6faf5bfd032ac7915432e614eb8.png)

7.代码运行完成，清空栈

![第7步](http://n1image.hjfile.cn/mh/2016/12/14/a68daa08f4a97c0f28ec4e6d4ca0bc7d.png)

这就是一段简单的代码在堆栈中的执行情况，看明白了就能开始介绍Javascript引擎的另外一个机制。

## Event Loop

众所周知，**Javascript引擎**（以下简称*JS引擎*）是单线程的，在某一个特定的时间内只能执行一个任务，并阻塞其他任务的执行，也就是说这些任务是串行的。这样的话，用户不得不等待一个耗时的操作完成之后才能进行后面的操作，这显然是不能容忍的，但是实际开发中我们却可以使用异步代码来解决。举个特殊栗子——计算机CPU，我们可以听着音乐的同时愉快的码代码，看起来播放音乐和编辑代码是并行的，其实不然。在计算机中并没有绝对意义上的并行，从微观上来看，单核心的CPU其实在同一个时间片内只能处理单一的任务，一旦某个进程的时间片结束，CPU会马上调度另一个进程执行，先前的进程则处于挂起状态等待获得时间片后继续执行，如此反复，宏观上看起来这些任务就是并行处理的。

回到我们熟悉的JS引擎，为实现这样的特性，这里就需要引申出一个重要的东西，*Event Loop*（事件循环）。

当异步方法比如这里的**setTimeout()**，或者**ajax请求**、**DOM事件执行**的时候，会交由浏览器内核的其他模块去管理。当异步的方法满足触发条件后，该模块就会将方法推入到一个任务队列（*task queue*）中，当主线程代码执行完毕处于空闲状态的时候，就会去检查任务队列，将队列中第一个任务入栈执行，完毕后继续检查任务队列，如此循环。前提条件是主线程处于空闲状态，这就是事件循环的模型。

## SetTimeout();

明白了上面的东西，那理解setTimeout的机制就容易得多了。回到开篇的第一段代码：

```javascript
console.log('start');

//Timer1
setTimeout(function () {
    console.log('hello');
}, 200);

//Timer2
setTimeout(function () {
    console.log('world');
}, 100);

console.log('end');
```
为了让大家更直观的看到执行的顺序，做了一个GIF

![执行步骤gif](http://n1image.hjfile.cn/mh/2016/12/15/7213bb28fd30caa871d8ef75f425475a.gif)

图上可以看出，首先依然是main()开始，首先第一个console.log()入栈执行，执行完毕控制台打印'start'后出栈，紧接着执行到setTimeout定时器，此时JS引擎会将定时器交给浏览器的另一个模块去管理（为方便理解这里把它叫做Timer模块），然后主线程继续向下执行，紧接着将第二个定时器也交给Timer模块，然后执行到第二个console.log()，控制台打印'end'，执行完毕后清空执行栈。但是并没有结束，在主线程执行的同时，Timer模块会检查其中的异步代码，一旦满足触发条件，就会将它添加到任务队列中。Timer2延迟100ms，所以会早于Timer1被添加到队列排头。而主线程此时处于空闲状态，所以会检查任务队列是否有待执行的任务。此时会将Timer2回调中的console.log()执行，控制台打印'world'，然后执行栈空闲后继续检查任务队列，将Timer1的代码压入执行栈中执行，控制台打印'hello'，清空执行栈，此时任务队列为空，执行结束。

控制台依次打印出：

![控制台打印](http://n1image.hjfile.cn/mh/2016/12/15/cebca6ff2376a956c7068066827c6557.png)

再来看开篇第二段改版代码，就比较好玩了：

```javascript
console.log('start');

//Timer1
setTimeout(function () {
    console.log('hello');
}, 200);

//Timer2
setTimeout(function () {
    console.log('world');
}, 300);

// 此处仅代表模拟一个耗时运算，这里假设时间大于1秒，
// 便于理解本文的重点，此处不需要过分探究执行时间
for (var i=0;i<10000;i++) {
    console.log(1);
}

//Timer3
setTimeout(function () {
    console.log('I am run');
}, 100);

console.log('end');
```
和第一段不同的是，在最后一个定时器前加了一段for循环，（注：此处仅用来模拟一段比较耗时的运算，假设时间大于1秒，代码真正执行时间不必深究）。chrome控制台运行结果是：

![控制台打印](http://n1image.hjfile.cn/mh/2016/12/15/ac2f1caa8cf74b0c699567a66dd59e2b.png)

前面的那张Gif图看懂了以后，其实从'world'之前的打印应该都是没有问题的。但是奇怪的地方就是，Timer3仅仅延迟了100ms，反而在另外两个Timer之后执行了。其实这里原因很简单，因为在Timer1和Timer2加入到执行队列中后，主线程依然还在执行for循环中的代码，处于阻塞状态。队列中的Timer1和Timer2并不会得以执行。当for循环结束，这时才将Timer3交由Timer模块去管理，继续执行后续代码打印'end'，清空执行栈。虽然在这里Timer3的延迟时间最短，但是加入任务队列后还是会排在Timer1和Timer2的后面，所以此时按顺序执行任务队列中的代码，依次打印'hello'、'world'、'I am run'。同时需要注意的是，这种情况下的三个定时器延迟执行的时间已经远远超过了指定的时间。

还有一点值得特别注意的是，有些同学可能会写过这样的代码：

```javascript
setTimeout(function () {}, 0);
```
其实JS引擎在处理这段代码的时候，并不是真正的延迟0ms执行。不同的浏览器会默认有一个最小的延迟时间，低于这个时间间隔会按照默认最小的时间间隔来处理。

## 总结

我们发现不论事件循环（_Event Loop_）模型还是setTimeout机制，其实并不是难点，但却是很多开发同学容易忽略的点。很多问题的产生可能就是因为忽略了一些简单的原理导致的。所以这些基本的知识点需要掌握扎实，才能更好的驾驭Javascript。如果有兴趣可以翻墙看一看下面参考中的视频，强烈推荐！

## 参考资料


> [Philip Roberts: What the heck is the event loop anyway?](https://www.youtube.com/watch?v=8aGhZQkoFbQ)