//
//  BaseNavigationController.h
//  ShoppingAPP
//
//  Created by qianfeng on 16/2/16.
//  Copyright (c) 2016年 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
@interface BaseNavigationController : UINavigationController
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)NSString *titleName;
@end
