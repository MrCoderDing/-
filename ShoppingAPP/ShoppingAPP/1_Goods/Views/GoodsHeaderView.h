//
//  GoodsHeaderView.h
//  ShoppingAPP
//
//  Created by qianfeng on 16/1/27.
//  Copyright (c) 2016年 JC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GoodsHeaderView : UICollectionReusableView
@property(nonatomic,copy)void(^UrlBlock)(NSString *url,NSString *title);

@end
