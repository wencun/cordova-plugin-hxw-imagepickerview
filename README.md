## 安装

##### 添加插件

在工程主文件夹执行

`cordova plugin add https://github.com/wencun/cordova-plugin-hxw-imagepickerview.git --save`

##### 卸载插件

在工程主文件夹执行

`cordova plugin rm cordova-plugin-hxw-imagepickerview`

## IOS图片多张选择插件使用

在需要使用插件的地方引入如下代码

```javascript
    var retDic = {
        maxSelectCount: 3,
        imgUuid:[
            this.imageName_1,this.imageName_2,this.imageName_3
        ]//已经选择的ID
    }
    cordova.plugins.YXWImagePickerView.openImagePickerView(retDic, (successRet) => {

    }, (errorRet) => {
  	
    });
```
##### 传入参数（json）

`maxSelectCount`   //最大选择图片数量，必须大于0

`imgUuid`  //第一次传可为空，为图片标识

##### 传出参数（json）

`mgUuid`  //数组，图片标识，可以再次调用的时候回传

`imgPath`  //数组，图片地址

## 刷新页面

如果页面没有刷新，可添加如下代码

1. 引入

`import { ChangeDetectorRef } from '@angular/core';`

2. 让 Angualr 注入变量

`constructor(private cd: ChangeDetectorRef) {}`

3. 在需要刷新的地方执行

```javascript
this.cd.markForCheck();
this.cd.detectChanges();
```

