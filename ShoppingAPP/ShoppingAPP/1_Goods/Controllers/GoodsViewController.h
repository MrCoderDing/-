//
//  GoodsViewController.h
//  ShoppingAPP
//
//  Created by qianfeng on 16/1/22.
//  Copyright (c) 2016年 JC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ICSDrawerController.h"

@interface GoodsViewController : UIViewController<ICSDrawerControllerChild, ICSDrawerControllerPresenting>
@property (nonatomic,weak) ICSDrawerController *drawer;
/**
 *  商品分类
 */
@property(nonatomic,strong) NSNumber *cid;
@property(nonatomic,strong) UILabel *titleLabel;
//单例,用来接收侧边菜单的传值
+(instancetype)defaultGoodsViewController;

- (void)turnToTop;
@end
