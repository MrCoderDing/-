//
//  RefreshHeader.m
//  ShoppingAPP
//
//  Created by qianfeng on 16/2/25.
//  Copyright © 2016年 JC. All rights reserved.
//

#import "RefreshHeader.h"

@implementation RefreshHeader

- (void)prepare
{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loads%zd", i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 0; i<=6; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading%zd", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:idleImages          forState:MJRefreshStateRefreshing];
}

@end
