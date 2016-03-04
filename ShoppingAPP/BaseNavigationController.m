//
//  BaseNavigationController.m
//  ShoppingAPP
//
//  Created by qianfeng on 16/2/16.
//  Copyright (c) 2016年 JC. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];

//    [self createCustomBar];
    [self createToolBar];
    
}
- (void)setTitleName:(NSString *)titleName{
    _titleName = titleName;
    _titleLabel.text = _titleName;
    self.title = titleName;
}

- (void)initNav{
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = COLOR;
}
- (void)createCustomBar{
    
    UIView *myBar = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_SIZE.origin.x, SCREEN_SIZE.origin.y, SCREEN_SIZE.size.width, 64)];
    [myBar setBackgroundColor:COLOR];
    [self.view addSubview:myBar];
    _titleLabel      = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    _titleLabel.center        = myBar.center;
    _titleLabel.textColor     = [UIColor whiteColor];
    _titleLabel.text          = self.titleName;
    
    _titleLabel.font          = [UIFont boldSystemFontOfSize:18];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [myBar addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(myBar.mas_bottom).offset(-10);
        make.centerX.equalTo(myBar.mas_centerX);
    }];
    
}
- (void)createToolBar{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
