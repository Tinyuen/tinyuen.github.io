---
title: URL.createObjectURL 实现本地图片预览
date: 2020-04-05 23:30:00
categories:
- web前端
tags:
- JavaScript
---

本地图片预览应该算是一个比较常见的需求，无需依赖服务端返回图片的地址，前端可以直接在本地预览图片。
 <!-- more -->

本地图片预览应该算是一个比较常见的需求，无需依赖服务端返回图片的地址，前端可以直接在本地预览图片。比较常见的就是使用 HTML5 的 FileReader API 来实现，但是今天我们介绍另外一种实现方式。使用 URL.createObjectURL 来实现。

## 何为 createObjectURL
`URL.createObjectURL()` 静态方法会创建一个 `DOMString`，其中包含一个表示参数中给出的对象的URL。这个 URL 的生命周期和创建它的窗口中的 document 绑定。这个新的URL 对象表示指定的 `File` 对象或 `Blob` 对象。

## 语法
```javascript
objectURL = URL.createObjectURL(object);
```
object：用于创建 URL 的 File 对象、Blob 对象或者 MediaSource 对象。​

## 示例
以下示例代码都是精简过的代码，只包含关键部分。实际项目中使用可以使用自己喜欢的方式封装，以达到更好的复用性。

index.html
```html
<head>
  <script src="./image-previewer.js"></script>
</head>

<!--文件选择-->
<input type="file" id="file">

<!--显示预览的图片-->
<div id="container"></div>

<script>
  window.onload = function () {
    imgPreviewer();  
  }
</script>
```
image-previewer.js
```javascript
function imgPreviewer () {
  document.getElementById('file').onchange = function (e) {
    var ele = document.getElementById('file').files[0];
    var createObjectURL = function (blob) {
      return window[window.webkitURL ? 'webkitURL' : 'URL']['createObjectURL'](blob);
    };

    var imgDta = createObjectURL(ele);
    var pvImg = new Image();
    pvImg.src = imgDta;
    pvImg.setAttribute('id', 'previewImg');

    document.getElementById('container').innerHTML = '';
    document.getElementById('container').appendChild(pvImg);
  }
}
```

以上就是代码的关键部分，只保留的精简的逻辑。在实际项目中使用时候，需要增加一些容错的判断，比如文件的后缀名判断，或者文件大小的限制等等。大家自行补全即可。

文件本地预览还有一个比较方便的 API 就是 `FileReader`，大家可以去看下，使用也是比较简单的。



