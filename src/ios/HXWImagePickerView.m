/********* YHCardScan.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import "LGPhoto.h"
//#import "SVProgressHUD.h"
#define HEADER_HEIGHT 100

@interface HXWImagePickerView : CDVPlugin <LGPhotoPickerViewControllerDelegate> {
    
}
@property (nonatomic, copy) NSString *callbackId;
@property (nonatomic, strong) NSMutableDictionary *resultDict;
//@property (nonatomic, assign) LGShowImageType showType;

- (void)openImagePickerView:(CDVInvokedUrlCommand*)command;

@end

@implementation HXWImagePickerView

- (void)openImagePickerView:(CDVInvokedUrlCommand*)command {
    
    self.callbackId = command.callbackId;
    NSDictionary *dict  = [command argumentAtIndex:0 withDefault:nil];
    if (dict) {
        
        NSInteger maxCount = [[NSString stringWithFormat:@"%@", dict[@"maxSelectCount"]] integerValue];
        if (maxCount <= 0) {
            [self failedCallBack:@"参数错误"];
        }
        NSMutableArray *selectedAlAssetURL = dict[@"imgUuid"];
        
        _resultDict = [NSMutableDictionary dictionary];
        
        [self startSelectedImageMaxCount:maxCount selectedImageId:selectedAlAssetURL];
    } else {
        [self failedCallBack:@"参数错误"];
    }
}

- (void)startSelectedImageMaxCount:(NSUInteger)maxCount selectedImageId:(NSMutableArray *)selectedAlAssetURL{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSString *urlString in selectedAlAssetURL) {
        [array addObject:[NSURL URLWithString:urlString]];
    }
    LGPhotoPickerViewController *pickerVc = [[LGPhotoPickerViewController alloc] initWithShowType:LGShowImageTypeImagePicker];
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.maxCount = maxCount;   // 最多能选maxCount张图片
    pickerVc.selectedAssetURL = array;
    pickerVc.delegate = self;
    //        pickerVc.nightMode = YES;//夜间模式
    //    self.showType = LGShowImageTypeImagePicker;
    [pickerVc showPickerVc:self.viewController];
}

- (void)successCallBack:(NSDictionary *)cardDic {
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:cardDic];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

- (void)failedCallBack:(NSString*)errorString {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errorString];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

#pragma mark - STIDCardScannerDelegate

- (void)didCancel {
    //    dispatch_async(dispatch_get_main_queue(), ^{
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
    //    });
}

#pragma mark - LGPhotoPickerViewControllerDelegate

- (void)pickerViewControllerDoneAsstes:(NSArray *)assets isOriginal:(BOOL)original{
//    [SVProgressHUD showInfoWithStatus:@"图片正在处理中..."];
    /*
     //assets的元素是LGPhotoAssets对象，获取image方法如下:
     NSMutableArray *thumbImageArray = [NSMutableArray array];
     NSMutableArray *originImage = [NSMutableArray array];
     NSMutableArray *fullResolutionImage = [NSMutableArray array];
     */
    NSMutableArray *imageKeyArray = [NSMutableArray array];
    NSMutableArray *imagePathArray = [NSMutableArray array];
    for (LGPhotoAssets *photo in assets) {
        CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
        NSString *imgName = [[NSString stringWithFormat:@"%f", startTime] stringByReplacingOccurrencesOfString:@"." withString:@""];
        //        CFAbsoluteTime statTime = CFAbsoluteTimeGetCurrent();
        NSString *imgPath = [self saveImgToFileSystem:photo.originImage imgName:[NSString stringWithFormat:@"%@.png", imgName]];
        //        CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent() - statTime;
        //        NSLog(@"时间：%f, path:%@", endTime * 1000, imgPath);
        [imageKeyArray addObject:[photo.assetURL absoluteString]];
        [imagePathArray addObject:imgPath];
        //缩略图
        //        [thumbImageArray addObject:photo.thumbImage];
        //        //原图
        //        [originImage addObject:photo.originImage];
        //        //全屏图
        //        [fullResolutionImage addObject:fullResolutionImage];
    }
    [_resultDict setObject:imageKeyArray forKey:@"imgUuid"];
    [_resultDict setObject:imagePathArray forKey:@"imgPath"];
    [self successCallBack:_resultDict];
//    [SVProgressHUD dismiss];
    [self didCancel];
    
}

// 压缩 -> 保存 -> 返回路径
- (NSString*)saveImgToFileSystem:(UIImage*)img imgName:(NSString*)imgName {
    // 1.压缩照片
    NSData *imgData = [self compressImage:img toByte:500*1024];
    // 2.创建文件夹
    NSString *tempPath = NSTemporaryDirectory();
    NSFileManager *fileManager = [NSFileManager defaultManager];
    tempPath = [tempPath stringByAppendingPathComponent:@"hxwAssests/"];
    if(![fileManager fileExistsAtPath:tempPath]) {
        [fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    tempPath = [tempPath stringByAppendingPathComponent:imgName];
    
    // 3.保存文件
    BOOL ret = [imgData writeToFile:tempPath atomically:YES];
    if (ret) {
        //        UIImage *img = [UIImage imageWithContentsOfFile:tempPath];
        return tempPath;
    } else {
        return @"";
    }
}

- (NSData *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) {
        return data;
    }
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    if (data.length < maxLength) {
        return data;
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),(NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    return data;
}


@end

