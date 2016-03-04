//
//  LoadingView.m
//  ShoppingAPP
//
//  Created by qianfeng on 16/2/19.
//  Copyright © 2016年 JC. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView
- (instancetype)initWithView:(UIView *)view{
    self = [super init];
    if (self) {
        UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, BAR_HEIGHT, SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT)];
        bgview.backgroundColor = [UIColor whiteColor];
        bgview.alpha = 0.4;
        UIImageView *loadView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 12)];
        loadView.image = [UIImage animatedImageNamed:@"ic_page_loading_frame" duration:2];
        //屏幕中心
        loadView.center = CGPointMake(view.frame.size.width/2.0, view.frame.size.height/2.0);
        [self addSubview:bgview];
        [self addSubview:loadView];
    }
    return self;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
