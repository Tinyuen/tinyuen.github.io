---
title: CSS移动端自适应解决方案
date: 2020-02-21 20:00:46
categories:
- web前端
tags:
- CSS
---

都说前端开发苦逼，一大原因就是成天要面对千变万化的手机屏幕尺寸，解决数不尽的兼容性问题。移动端屏幕CSS自适应就是个非常常见的需求，今天就将平时工作中采用的方案分享出来。
<!--more-->
其实前端做CSS自适应的方案有很多，这次仅仅介绍一种在自己工作中比较常用的方案。具体步骤如下：

### 1. 根节点`font-size`处理逻辑：
```javascript
(function(designWidth, maxWidth) {
  var doc = document, win = window, docEl = doc.documentElement, tid;
  function refreshRem() {
    var width = docEl.getBoundingClientRect().width;
    maxWidth = maxWidth || 540;
    width > maxWidth && (width = maxWidth);
    var rem = (width * 100) / designWidth;
    docEl.style.fontSize = rem + 'px';
    var actualSize = parseFloat(window.getComputedStyle(document.documentElement)['font-size']);
    if (actualSize !== rem && actualSize > 0 && Math.abs(actualSize - rem) > 1) {
      var remScaled = rem * rem / actualSize;
      docEl.style.fontSize = remScaled + 'px';
    }
  }
  refreshRem();
  win.addEventListener('resize', function() {
    clearTimeout(tid);
    tid = setTimeout(refreshRem, 300);
  }, false);
  win.addEventListener('pageshow', function(e) {
    if (e.persisted) {
      clearTimeout(tid);
      tid = setTimeout(refreshRem, 300);
    }
  }, false);
  if (doc.readyState === 'complete') {
    doc.body.style.fontSize = '16px';
  } else {
    doc.addEventListener('DOMContentLoaded', function(e) {
      doc.body.style.fontSize = '16px';
    }, false);
  }
})(750, 750);
```

### 2. 在页面引入
将上述代码置于html的 `<head>` 标签中，优先于页面的css代码加载。
```html
<html>
    <head>
    <script><!-- 此处放上面的代码 --></script>
    <!-- 业务css代码放在后面 -->
    </head>
</html>
```

### 3. 编写css代码
配置好后，在css代码中就可以用`rem`代替`px`，一般开发中基本都会使用SASS或者LESS，所以可以借助函数来简化我们的开发工作。
```css
// 定义单位处理函数
@function p($px) {
    @return $px / 100 * 1rem;
}
// 假设设计稿宽度20px
.test {
    width: P(20);
}

// 最后编译成
.test {
    width: 0.2rem;
}
```

### 4. 一劳永逸的方法
其实不难发现，虽然SASS能够减轻我们很多的开发负担，但是每次写`p(20)`这样的代码还是会浪费很多时间。有没有一劳永逸的方法呢？
答案是有的。如果你开发中使用`Webpack`作为构建工具，那么`postcss-plugin-px2rem`插件（详见 [插件文档](https://github.com/pigcan/postcss-plugin-px2rem "插件文档"))就会是个好的选择。这样你就可以摆脱频繁写css函数的困扰，直接按照设计稿标注的px值来写就好了。

webpack 可以配置在对应sass文件的loader里面
```JavaScript
import autoprefixer from 'autoprefixer';
import px2rem from 'postcss-plugin-px2rem';

// 配置项
const px2remOption = {
  rootValue: 100,
  unitPrecision: 5,
  minPixelValue: 0,
  ignoreIdentifier: 'no',
}
const postcssLoader = {
  loader: 'postcss-loader',
  query: {
    plugins: [
      autoprefixer(),
      px2rem(px2remOption)
    ],
    minimize: true
  }
}
// 简化版webpack配置
export default {
  module: {
    loaders: [
      {
        test: /\.scss$/,
        loader: ['css-loader', postcssLoader, 'sass-loader'],
      },
    ]
  }
  ...
}
```

这样一来，css的写法感觉又回到了我们熟悉的样子，webpack会帮我编译成我们需要的rem单位。
```css
// 20px就是设计稿标注的尺寸
.test {
    width: 20px;
}
```

以上就是工作中用到的移动端适配方案。希望可以帮到你！