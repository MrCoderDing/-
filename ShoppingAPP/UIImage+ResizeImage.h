//
//  UIImage+ResizeImage.h
//  ShoppingAPP
//
//  Created by qianfeng on 16/1/22.
//  Copyright (c) 2016年 JC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ResizeImage)
/**
 * 设置图片宽高
 */
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;
@end
