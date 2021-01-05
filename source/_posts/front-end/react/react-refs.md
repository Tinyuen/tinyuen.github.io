---
title: React 中各种实现 Refs 的方式总结
date: 2020-05-29 23:11:38
from: 原创
categories:
- web前端
tags:
- React
- JavaScript
---

在常规的 React 数据流中，props 是父组件与子组件交互的唯一方式。要修改子元素，你需要用新的 props 去重新渲染子元素。然而，在少数情况下，你需要在常规数据流外强制修改子元素。被修改的子元素可以是 React 组件实例，或者是一个 DOM 元素。在这种情况下，React 提供了解决办法。
<!-- more -->

你可能首先会想到在你的应用程序中使用 `Refs` 来更新组件。如果是这种情况，请花一点时间，想想是不是可以通过 `state` 的方式来实现，React 不建议过多的使用 `Refs`。
`Refs` 会使组件的实例或者是DOM结构暴露，违反组件封装的原则。

但是有些场景下这会非常有用：

* 处理focus、文本选择或者媒体播放
* 触发强制动画
* 集成第三方DOM库

React 中不同的版本都提供了不同的 `Refs` 使用方式，今天来总结下。


## React.useRef

Hook 是 React 16.8 的新增特性。它可以让你在不编写 class 的情况下使用 state 以及其他的 React 特性。也就是说，以往无“状态的”函数式组件，现在也可以“有状态”了！，具体详见 React 的官方文档介绍，这里不做展开。

我们先看一段代码：

```typescript jsx
function TextInput() {
  const inputEl = useRef(null);
  const onButtonClick = () => {
    // `inputEl.current` 指向已挂载到 DOM 上的文本输入元素
    inputEl.current.focus();
  };
  return (
    <>
      <input ref={inputEl} type="text" />
      <button onClick={onButtonClick}>Focus the input</button>
    </>
  );
}
```

这里的 `useRef` 就是 React 新特性中提供的一种 `Hooks`（[Hooks API 索引](https://zh-hans.reactjs.org/docs/hooks-reference.html)）。

useRef 返回一个可变的 `ref` 对象，其 `.current` 属性被初始化为传入的参数（initialValue）。返回的 `ref` 对象在组件的整个生命周期内保持不变。这里 React 通过 `useRef` 方法返回的
`inputEl` 传入 `input` 的 `ref` 属性，用来指向真实的DOM元素。

当然 `useRef` 的作用不止于此....


## React.createRef

使用 `React.createRef()` 创建 `refs`，通过 `ref` 属性来获得 React 元素。当构造组件时，`refs` 通常被赋值给实例的一个属性，这样你可以在组件中任意一处使用它们。当一个 `ref` 属性被传递给一个 `render` 函数中的元素时，可以使用 `ref` 中的 `current` 属性对节点的引用进行访问。

我们来看一段代码：

```typescript jsx
class TextInput extends React.Component {
  constructor(props) {
    super(props);
    // 创建一个 ref
    this.textInput = React.createRef();
  }

  focusTextInput = () => {
    this.textInput.current.focus();
  }

  render() {
    return (
      <div>
        <input type="text" ref={this.textInput} />
        <input
          type="button"
          value="Focus the text input"
          onClick={this.focusTextInput}
        />
      </div>
    );
  }
}
```
通过 `React.createRef()` 创建了一个 ref 赋值给 `this.textInput`，传入 `input` 的 ref 属性，此时 `this.textInput.current` 将会拿到 input 的真实的 DOM，用来直接操作 DOM。
React 组件在加载时将 DOM 元素传入 ref 的回调函数，在卸载时则会传入 null。


## 为类（Class）组件添加 Ref

以上面的 Class 组件 `TextInput` 为基础组件，我们再来添加一个父组件：

```typescript jsx
class AutoFocusTextInput extends React.Component {
  constructor(props) {
    super(props);
    this.textInput = React.createRef();
  }

  componentDidMount() {
    this.textInput.current.focusTextInput();
  }

  render() {
    return (
      <TextInput ref={this.textInput} />
    );
  }
}
```

通过这种方式 `this.textInput.current` 将会引用到 `TextInput` 子组件的实例对象。用来调用子组件的方法。

需要注意的是，这种方法仅对以类(class)声明的 TextInput 有效！因为 Class 组件才会有实例对象。


## 为函数式（Functional）组件添加 Ref

因为 ref 属性只能用在 Class 组件上，所以下面这样使用将会是无效的。

```typescript jsx
function FunctionalInput() {
  return <input />;
}

class Parent extends React.Component {
  constructor(props) {
    super(props);
    this.textInput = React.createRef();
  }
  render() {
    // This will *not* work!
    return (
      <FunctionalInput ref={this.textInput} />
    );
  }
}
```

那函数式组件如何使用 Ref 呢？ 我看看一段代码:

```typescript jsx
function FunctionalInput(props) {
  // textInput 用来存储 ref
  let textInput = null;

  function handleClick() {
    textInput.focus();
  }

  return (
    <div>
      <input type="text" ref={input => textInput = input} />
      <input
        type="button"
        value="Focus the text input"
        onClick={handleClick}
      />
    </div>
  );  
}
```

React 将在组件挂载时将 input 的 DOM 元素传入 ref 回调函数并调用，这样 `textInput` 就会拿到 input 的DOM 引用。当卸载时会传入 null 并调用它该回调函数。

## 回调 Refs

回调 Ref 也是一种设置 `Refs` 的方式。ref 属性将会接受一个回调函数，这个函数接受 React 组件的实例或 HTML DOM 元素作为参数，以存储它们并使它们能被其他地方访问。

```typescript jsx
function FunctionalInput(props) {
  return (
    <div>
      <input ref={props.inputRef} />
    </div>
  );
}

class Parent extends React.Component {
  constructor(props) {
    super(props);
    this.textInput = null;
  }
  setInputRef = (el) => {
    this.textInput = el;
  }
  componentDidMount() {
    // 渲染后文本框自动获得焦点
    this.textInput.focus();
  }
  render() {
    return (
      <FunctionalInput inputRef={this.setInputRef} />
    );
  }
}
```
在上面的例子中，Parent 传递给它的 ref 回调函数作为 inputRef 传递给 FunctionalInput，然后 FunctionalInput 通过 ref 属性将其传递给 <input>。最终，Parent 中的 this.textInput 将被设置为与 FunctionalInput 中的 <input> 元素相对应的 DOM 节点。

## 暴露子组件的 DOM 节点

某些特殊的情况下，我们可能会需要在父组件中获取到子组件的某个DOM节点。正常情况下，如果是自定义组件，我们通过 Refs 的获取方式获取到的一般是组件的实例对象，
如果仅仅是希望获取到子组件的 DOM 节点，那么 `React.forwardRef` 将会帮上你的忙，前提是需要在 16.3 以上的版本。甚至搭配 `useImperativeMethods` 将会更完美。
详见另一篇文章：[React 的 Refs 转发 React.forwardRef]() 。


以上。
