## 简介

一个为Flutter端提供简便、易用组件的库

## Getting started

### 一、焦点组件

#### 1.UsefulFocusParent

焦点容器组件，默认提供线边框焦点样式，可自定义选择焦点样式，高度定制化

``` kotlin
  UsefulFocusParent(
    autoFocus: true,
    onClickListener: () {
        print("我被点击了...");
    },
    child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(focusStyleModel.radius),
            ),
            child: Center(
              child: Padding(
                padding: focusStyleModel.padding,
                child: Text(
                  textContent,
                  style: TextStyle(
                    color: textColor,
                    fontSize: focusStyleModel.fontSize,
                  ),
                ),
              ),
            ),
          ),
  );
```

#### 2.UsefulFocusButton

焦点按钮组件，基于 `UsefulFocusParent` 进行封装

``` kotlin
  UsefulFocusButton(
    autoFocus: true,
    onClickListener: () {
        print("我被点击了...");
    },
    textContent: '我是按钮',
    focusStyleModel: FocusStyleModel(
        focusBackgroundColor: Colors.blue,
        unFocusBackgroundColor: Colors.grey,
        ...
    )
  );
```

### 二、功能API

#### 1.debounce

防重复点击/防抖/节流

``` kotlin
   // ✅正确示例
   // [intervalDuration] 间隔多长时间执行，默认1秒
   InkWell(
     onTap: debounce(() {
      // 这里最快的回调频率为 1秒/次
      // todo something
     }, intervalDuration: const Duration(seconds: 1)),
     child: const Text('Test Click'),
   );
```

``` kotlin
   // ‍❌错误示例
   // 这种写法会失去闭包的特性，导致该功能失效
   InkWell(
     onTap: () {
        debounce(() {
            // todo something
        }, intervalDuration: const Duration(seconds: 1))
     },
     child: const Text('Test Click'),
   );
```