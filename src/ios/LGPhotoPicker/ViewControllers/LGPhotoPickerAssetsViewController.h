//
//  LGPhotoPickerAssetsViewController.h
//  LGPhotoBrowser
//
//  Created by ligang on 15/10/27.
//  Copyright (c) 2015年 L&G. All rights reserved.

#import <UIKit/UIKit.h>
#import "LGPhotoPickerCommon.h"
#import "LGPhotoPickerGroupViewController.h"

@class LGPhotoPickerGroup;

@interface LGPhotoPickerAssetsViewController : UIViewController

@property (nonatomic, assign) PickerViewShowStatus status;
//决定以什么风格显示相册，有原图选择按钮？有多选功能？
@property (nonatomic) LGShowImageType showType;

@property (nonatomic, strong) LGPhotoPickerGroup *assetsGroup;

@property (nonatomic, assign) NSInteger maxCount;

@property (nonatomic, assign) BOOL nightMode;
// 需要记录选中的值的数据
@property (nonatomic, strong) NSArray *selectPickerAssets;
// 记录选中值的URL（相当于key）可以根据传过来的这个key来获取选中的
@property (strong,nonatomic) NSMutableArray *selectedAssetURL;
// 置顶展示图片
@property (nonatomic, assign) BOOL topShowPhotoPicker;

@property (nonatomic, copy) void(^selectedAssetsBlock)(NSMutableArray *selectedAssets);
// 记录选中值的URL（相当于key）可以根据传过来的这个key来获取选中的
@property (copy, nonatomic) void(^selectedAssetsURLBlock)(NSMutableArray *selectedAssetURL);

- (instancetype)initWithShowType:(LGShowImageType)showType;

@end
