---
title: node中的path
date: 2017-05-18 20:00:46
type: 原创
categories:
- web前端
tags:
- Node
---

path 模块提供了一些工具函数，用于处理文件与目录的路径
 <!-- more -->

# Path
path 模块提供了一些工具函数，用于处理文件与目录的路径
 <!-- more -->
## 1. path.basename(path[, ext])
path.basename() 方法返回一个 path 的最后一部分
```javascript
path.basename('/aaa/bbb/ccc.html');
=> ccc.html
```

## 2. path.dirname(path)
path.dirname() 方法返回一个 path 的目录名
```javascript
path.basename('/aaa/bbb/ccc.html');
=> /aaa/bbb
```

## 3. path.extname(path)
path.extname() 方法返回 path 的扩展名，即从 path 的最后一部分中的最后一个 .（句号）字符到字符串结束。 如果 path 的最后一部分没有 . 或 path 的文件名（见 path.basename()）的第一个字符是 .，则返回一个空字符串。
```javascript
path.basename('/aaa/bbb/ccc.html');
=> .html
```

## 4. path.join([...paths])
path.join() 方法使用平台特定的分隔符把全部给定的 path 片段连接到一起，并规范化生成的路径。
```javascript
path.join('/a','b');             => '/a/b'
path.join('/a','b', '..', 'c')   => '/a/c'
```

## 5. path.relative(from, to)
path.relative() 方法返回从 from 到 to 的相对路径，通俗点将就是，从from为起点，to相对于它的路径
```javascript
path.relative('/a/b/c/test', '/a/b/d/test2');
=> '../../d/test2'
```

## 6. path.resolve([...paths])
path.resolve() 方法会把一个路径或路径片段的序列解析为一个绝对路径。给定的路径的序列是从右往左被处理的，后面每个 path 被依次解析，直到构造完成一个绝对路径后返回。如果处理完全部给定的 path 片段后还未生成一个绝对路径，则当前工作目录会被用上。
```javascript
path.resolve('/a/b', './test');             => /a/b/test
path.resolve('a', 'b/c/', '../d/test');     => /home/toy/a/b/d/test
```

# File System

## 1. fs.open(path, flags[, mode], callback)
异步地打开文件,callback有两个参数 err和fd  fd是返回的文件描述符
```javascript
fs.open('./a.txt', 'r', '0666', function (err, fd) {
    console.log(fd);
});
```

## 2. fs.read(fd, buffer, offset, length, position, callback)
从 fd 指定的文件中读取数据。
buffer 是数据将被写入到的 buffer。
offset 是 buffer 中开始写入的偏移量。
length 是一个整数，指定要读取的字节数。
position 是一个整数，指定从文件中开始读取的位置。 如果 position 为 null，则数据从当前文件位置开始读取。

## 3. fs.readFile(file[, options], callback)
异步的读取一个文件的全部内容,如果字符编码未指定，则返回原始的 buffer。它是对read方法的一个进一步封装

```javascript
fs.readFile('./a.txt', (err, data) => {
    if (err) throw err;
    console.log(data);
});

fs.readFile('./a.txt', 'utf-8', (err, data) => {
    if (err) throw err;
    console.log(data);
});
```
---
## Demo - 读取文件
```javascript
fs.open('./a.txt', 'r', (err, fd) => {
    if (err) {
        throw err;
        return;
    }
    let buf = Buffer.alloc(255);
    fs.read(fd, buf, 0, 6, null, function(err, byteRead, buffer) {
        console.log(byteRead); // 实际读取的字节数
        console.log(buffer.toString());   // 被读取的缓存区buffer
        fs.close(fd, err => {
            throw err;
        })
    })
})
```
---

## 4. fs.write(fd, data[, position[, encoding]], callback)
写入 data 到 fd 指定的文件。 如果 data 不是一个 Buffer 实例，则该值将被强制转换为一个字符串。
position 指向从文件开始写入数据的位置的偏移量，encoding 是期望的字符串编码。回调有三个参数 (err, written, string)，其中 written 指定传入的字符串被写入多少字节

在 Linux 上，当文件以追加模式打开时，指定位置的写入是不起作用的。 内核会忽略位置参数，并总是将数据追加到文件的末尾。


## 5. fs.writeFile(file, data[, options], callback)
异步地写入数据到文件，如果文件已经存在，则写入的内容会替换原有的内容，没有则创建文件。 data 可以是一个字符串或一个 buffer。如果 data 是一个 buffer，则忽略 encoding 选项。它默认为 'utf8'。

它是对write方法的进一步封装
```javascript
fs.writeFile('./a.txt', 'Hello Node.js', (err) => {
    if (err) throw err;
    console.log('write finshed!');
});
```
---
> fs.write()和fs.writeFile()方法的比较(同read)

与fs.readFile()方法和fs.read()方法的关系类似。fs.writeFile()也是对fs.write()方法的进一步封装，使用fs.readFile()方法省略了创建文件描述符的过程，可以更方便的向文件写入数据。

> fs.close() 打开的文件最后需要及时关掉

其实如果不调用close()并不会立即抛出异常，但是Node对同时打开的文件数量是有限制的。如果你不停的open一个文件而不close，最后将会抛出异常：EMFILE: too many open files error.

---

## 6. fs.appendFile(file, data[, options], callback)
异步地追加数据到一个文件，如果文件不存在则创建文件。 data 可以是一个字符串或 buffer。
```javascript
fs.appendFile('./a.txt', ', Hello Hujiang!', (err) => {
    if (err) throw err;
    console.log('append complete!');
});
```

---
## Demo - 写入内容到文件
注意此时应该用读写模式打开文件，否则写入不成功，会报错
```javascript
fs.open('./a.txt', 'r+', (err, fd) => {
    if (err) {
        throw err;
        return;
    }
    let buf = Buffer.from('Nodejs好牛逼');
    //只写入“好牛逼”这三个字
    fs.write(fd, buf, 6, 9, 0, function(err, written, buffer) {
        if (err) throw err;
        console.log(written); // 实际读取的字节数
        console.log(buffer.toString());   // 被读取的缓存区buffer
        fs.close(fd, err => {
            throw err;
        })
    })
})
```

刷新缓存区
```javascript
fs.open('./a.txt', 'r+', (err, fd) => {
    if (err) {
        throw err;
        return;
    }
    let buf = Buffer.from('Nodejs好牛逼');
    //只写入“好牛逼”这三个字
    fs.write(fd, buf, 0, 6, 0, function(err, written, buffer) {
        if (err) throw err;
        console.log(written); // 实际写入的字节数
        fs.write(fd, buf, 6, 6, null, function(err, written, buffer) {
            console.log(written);

        })
    })
})
```
---
