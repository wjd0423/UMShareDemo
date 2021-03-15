//
//  EEOUMShareApiProxy.h
//  EEOTPSDK
//
//  Created by eeo开发-东哥 on 2020/11/3.
//  Copyright © 2020 jiangmin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
  友盟分享 platformType对应的平台：
 0：新浪
 1：微信好友
 2：微信朋友圈
 4：QQ
 5：QQ空间
 16：Facebook
 17：Twitter
 22：Linkedin
 */

typedef void(^shareResultBlock)(BOOL result);

@class UIViewController;
@interface EEOUMApiProxy : NSObject

+ (void)registerUMSetting;
+ (void)setAnalyticsEnabled:(BOOL)enabled;
+ (void)registerUSharePlatforms;

+ (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

+ (BOOL)handleOpenURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options;

+ (BOOL) isInstall:(NSInteger)platformType;
/**
 文本分享
 */
+ (void)shareTextToPlatformType:(NSInteger)platformType withText:(NSString *)text currentViewController:(UIViewController *)currentViewController;

/**
 图文分享，如果只需要分享图片，则shareText传nil即可
 thumb为缩略图，可不传
 image为图片，必须传
 注意：linkedin仅支持URL图片，其他平台传UIImage或者URL或者NSData都可以
 */
+ (void)shareImageToPlatformType:(NSInteger)platformType withThumb:(nullable id)thumb image:(id)image shareText:(NSString *)shareText currentViewController:(UIViewController *)currentViewController shareResulBlock:(shareResultBlock)shareResult;

/**
 网页链接分享
 */
+ (void)shareWebPageToPlatformType:(NSInteger)platformType withTitle:(NSString *)title descr:(NSString *)descr url:(NSString *)url thumb:(id)thumb currentViewController:(UIViewController *)currentViewController;

/**
 视频分享
 */
+ (void)shareVedioToPlatformType:(NSInteger)platformType withUrlString:(NSString *)url title:(NSString *)title descr:(NSString *)descr thumImage:(id)thumImage currentViewController:(UIViewController *)currentViewController;

/**
 文件分享
 */
+ (void)shareFileToPlatformType:(NSInteger)platformType withFileData:(NSData *)fileData fileExtension:(NSString *)fileExtension title:(NSString *)title descr:(NSString *)descr thumImage:(id)thumImage currentViewController:(UIViewController *)currentViewController;

/** 自动页面时长统计, 开始记录某个页面展示时长.
 使用方法：必须配对调用beginLogPageView:和endLogPageView:两个函数来完成自动统计，若只调用某一个函数不会生成有效数据。
 在该页面展示时调用beginLogPageView:，当退出该页面时调用endLogPageView:
 @param pageName 统计的页面名称.
 */
+ (void)beginLogPageView:(NSString *)pageName;

/** 自动页面时长统计, 结束记录某个页面展示时长.
 使用方法：必须配对调用beginLogPageView:和endLogPageView:两个函数来完成自动统计，若只调用某一个函数不会生成有效数据。
 在该页面展示时调用beginLogPageView:，当退出该页面时调用endLogPageView:
 @param pageName 统计的页面名称.
 */
+ (void)endLogPageView:(NSString *)pageName;

/** 自定义事件,数量统计.
使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID
 
 @param  eventId 网站上注册的事件Id.
 */
+ (void)event:(NSString *)eventId; //等同于 event:eventId label:eventId;
/** 自定义事件,数量统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID
 @param  label 分类标签。不同的标签会分别进行统计，方便同一事件的不同标签的对比,为nil或空字符串时后台会生成和eventId同名的标签.
 */
+ (void)event:(NSString *)eventId label:(NSString *)label; // label为nil或@""时，等同于 event:eventId label:eventId;

/** 自定义事件,数量统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID
 */
+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes;

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes counter:(int)number;

+ (void)profileSignInWithPUID:(NSString *)puid;

+ (void)profileSignOff;

@end

NS_ASSUME_NONNULL_END
