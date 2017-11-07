## 安装

##### 添加插件

在工程主文件夹执行

`cordova plugin add https://github.com/wencun/cordova-plugin-hxw-ocr.git --save`

##### 卸载插件

在工程主文件夹执行

`cordova plugin rm com.yhloan.YHCardScan`

## 银行卡扫描插件使用

在需要使用插件的地方引入如下代码

```javascript
    var retDic = {
      API_ID: '',
      API_SECRET: '',
      Phone_Number: ''
    }
    cordova.plugins.YHCardScan.scanBankCard(retDic, (successRet) => {

    }, (errorRet) => {
  	
    });
```
##### 传入参数（json）

`API_ID`  

`API_SECRET` 

`Phone_Number`

##### 传出参数（json）

`BankNumber`  发卡行名称

`BankIdentificationNumber`  发卡行标识代码

`CardName`  卡片名称

`CardType`  卡片类型

`BankImgUrl`  图片的URL

## 身份证正反扫描插件使用

在需要使用插件的地方引入如下代码

```javascript
	var retDic = {
      API_ID: '',
      API_SECRET: '',
      detectedImageName: '',
      faceImageName:'',
      backImageName:''
    }
    cordova.plugins.YHCardScan.scanIDCard(retDic, (successRet) => {

    }, (errorRet) => {

    });
```
##### 传入参数（json）

`API_ID` 

`API_SECRET` 

`detectedImageName` 身份证正面检测图片名称，如：detected.png

`faceImageName`  身份证正面头像名称，如：face.png

`backImageName`  身份证反面检测图片名称，如：back.png

##### 传出参数（json）

`name`  姓名

`cardID`  身份证号码

`sex`  性别

`nation`  民族

`birthDate`  出生

`address`  住址

`authority` 签发机关

`validity` 有效期限

`detectedPath`   身份证正面检测图片URL

`facePath`   身份证正面头像图片URL

`backPath`   身份证反面检测图片URL


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

