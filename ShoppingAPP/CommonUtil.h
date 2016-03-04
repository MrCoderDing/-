//
//  CommonUtil.h
//  ShoppingAPP
//
//  Created by qianfeng on 16/2/17.
//  Copyright (c) 2016年 JC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CommonUtil : NSObject
//将view转为image
+ (UIImage *)getImageFromView:(UIView *)view;

//根据比例（0...1）在min和max中取值
+ (float)lerp:(float)percent min:(float)nMin max:(float)nMax;
/**
 *  给父视图添加等待动画
 *
 *  @param view 父视图
 */
+ (void)addLoadingViewOn:(UIView *)view;

/**
 *  移除加载动画
 *  @param
 */
+ (void)removeLoadingViewOn:(UIView *)view;
/**
 *  跳转到webView
 *
 *  @param url   链接
 *  @param title 标题名
 */
+ (void)gotoWebView:(NSString *)url andTitle:(NSString *)title At:(UIViewController *)vc;
+ (void)gotoWebView:(NSString *)url andTitle:(NSString *)title andImg:(UIImage *)img At:(UIViewController *)vc;
/**
 *  保存title和url到本地路径
 *
 *  @param title 网页标题
 *  @param url   网页url
 */

+ (void)saveLocalFavouriteTitle:(NSString *)title andUrl:(NSString *)url ;


/**
 *  读取保存的本体数据
 *
 *  @return 数据字典
 */
+ (NSDictionary *)readLocalFavourite;

/**
 *  根据title删除保存数据
 *
 *  @param title 要删除数据的title
 */
+ (void)delectLocalFavouriteByTitle:(NSString *)title;

/**
 *  得到目录文件大小
 *
 *  @param folderPath 文件路径
 *
 *  @return 路径大小
 */
+ (CGFloat)folderSizeAtPath:(NSString *)folderPath;



+ (BOOL)isExistInFavourite:(NSString *)title;

+(NSString *)readUrlByTitle:(NSString *)title;
@end
