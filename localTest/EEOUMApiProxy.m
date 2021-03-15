//
//  EEOUMShareApiProxy.m
//  EEOTPSDK
//
//  Created by eeo开发-东哥 on 2020/11/3.
//  Copyright © 2020 jiangmin. All rights reserved.
//

#import "EEOUMApiProxy.h"
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>
#import <UMCommon/MobClick.h>

static NSString * const kUMCCommonAppKey = @"5f9a7c0845b2b751a91f3ee4";
static NSString * const kQQAppId = @"1106915945";
static NSString * const kUniversalLink = @"https://www.eeo.cn/s/";

@implementation EEOUMApiProxy

+ (void)registerUMSetting{
    /* 注册友盟的appKey */
#if DEBUG
    [UMConfigure setLogEnabled:YES];
#endif
    [UMConfigure initWithAppkey:kUMCCommonAppKey channel:@"App Store"];
    [UMConfigure setAnalyticsEnabled:NO];
}

+ (void)setAnalyticsEnabled:(BOOL)enabled{
    [UMConfigure setAnalyticsEnabled:enabled];
}

+ (void)registerUSharePlatforms{
    
    //微信和QQ完整版会校验合法的universalLink，不设置会在初始化平台失败
    [UMSocialGlobal shareInstance].universalLinkDic= @{
//        @(UMSocialPlatformType_WechatSession):kUniversalLink,
        @(UMSocialPlatformType_QQ):kUniversalLink,
    };
    
    /* 设置分享到QQ互联的appID
     QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kQQAppId appSecret:nil redirectURL:nil];
}

+ (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
}

+ (BOOL)handleOpenURL:(NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options{
    return [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
}

+ (BOOL)isInstall:(NSInteger)platformType {
    return [[UMSocialManager defaultManager] isInstall:platformType];
}
//分享文本
+ (void)shareTextToPlatformType:(NSInteger)platformType withText:(NSString *)text currentViewController:(UIViewController *)currentViewController{
    platformType = (UMSocialPlatformType)platformType;
        
    if (![[UMSocialManager defaultManager] isInstall:platformType]) {
        NSLog(@"未安装应用");
    }
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = text;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:currentViewController completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"Share fail with error %@",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                NSLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                NSLog(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                NSLog(@"response data is %@",data);
            }
        }
    }];
}

//分享图片
+ (void)shareImageToPlatformType:(NSInteger)platformType withThumb:(nullable id)thumb image:(id)image shareText:(NSString *)shareText currentViewController:(UIViewController *)currentViewController shareResulBlock:(nonnull shareResultBlock)shareResult{
    platformType = (UMSocialPlatformType)platformType;
    
    if (![[UMSocialManager defaultManager] isInstall:platformType]) {
        NSLog(@"未安装应用");
    }
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    if (shareText.length > 0) {
        messageObject.text = shareText;
    }
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图本地
    if (thumb) {
        shareObject.thumbImage = thumb;
    }
    shareObject.shareImage = image;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:currentViewController completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"Share fail with error %@",error);
            if (shareResult) {
                shareResult(NO);
            }
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                NSLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                NSLog(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                NSLog(@"response data is %@",data);
            }
            if (shareResult) {
                shareResult(YES);
            }
        }
    }];
}

//网页分享
+ (void)shareWebPageToPlatformType:(NSInteger)platformType withTitle:(NSString *)title descr:(NSString *)descr url:(NSString *)url thumb:(id)thumb currentViewController:(UIViewController *)currentViewController{
    platformType = (UMSocialPlatformType)platformType;
    
    if (![[UMSocialManager defaultManager] isInstall:platformType]) {
        NSLog(@"未安装应用");
    }
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:thumb];
    //设置网页地址
    shareObject.webpageUrl = url;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:currentViewController completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"Share fail with error %@",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                NSLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                NSLog(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                NSLog(@"response data is %@",data);
            }
        }
    }];
}

//视频分享
+ (void)shareVedioToPlatformType:(NSInteger)platformType withUrlString:(NSString *)url title:(NSString *)title descr:(NSString *)descr thumImage:(id)thumImage currentViewController:(UIViewController *)currentViewController{
    platformType = (UMSocialPlatformType)platformType;
    
    if (![[UMSocialManager defaultManager] isInstall:platformType]) {
        NSLog(@"未安装应用");
    }
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:title descr:descr thumImage:thumImage];
    //设置视频网页播放地址
    shareObject.videoUrl = url;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:currentViewController completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"Share fail with error %@",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                NSLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                NSLog(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                NSLog(@"response data is %@",data);
            }
        }
    }];
}

//文件分享
+ (void)shareFileToPlatformType:(NSInteger)platformType withFileData:(NSData *)fileData fileExtension:(NSString *)fileExtension title:(NSString *)title descr:(NSString *)descr thumImage:(id)thumImage currentViewController:(UIViewController *)currentViewController{
    platformType = (UMSocialPlatformType)platformType;
    
    if (![[UMSocialManager defaultManager] isInstall:platformType]) {
        NSLog(@"未安装应用");
    }
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    UMShareFileObject *shareObject = [UMShareFileObject shareObjectWithTitle:title descr:descr thumImage:thumImage];
    shareObject.fileData = fileData;
    shareObject.fileExtension = fileExtension;
    
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:currentViewController completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"Share fail with error %@",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                NSLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                NSLog(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                NSLog(@"response data is %@",data);
            }
        }
    }];
}

#pragma mark - 统计
+ (void)beginLogPageView:(NSString *)pageName {
    [MobClick beginLogPageView:pageName];
}

+ (void)endLogPageView:(NSString *)pageName {
    [MobClick endLogPageView:pageName];
}

+ (void)event:(NSString *)eventId {
    [MobClick event:eventId];
}

+ (void)event:(NSString *)eventId label:(NSString *)label {
    [MobClick event:eventId label:label];
}

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes {
    [MobClick event:eventId attributes:attributes];
}

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes counter:(int)number {
    [MobClick event:eventId attributes:attributes counter:number];
}

+ (void)profileSignInWithPUID:(NSString *)puid{
    [MobClick profileSignOff];
    [MobClick profileSignInWithPUID:puid];
}

+ (void)profileSignOff{
    [MobClick profileSignOff];
}

@end
