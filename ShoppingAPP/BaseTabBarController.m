//
//  BaseTabBarController.m
//  ShoppingAPP
//
//  Created by qianfeng on 16/1/22.
//  Copyright (c) 2016年 JC. All rights reserved.
//

#import "BaseTabBarController.h"

#import "UIImage+ResizeImage.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTabBar];
}

- (void)initTabBar{
    //设置状态栏字体颜色
     [[ UIApplication sharedApplication ] setStatusBarStyle : STATUS_BAR_STYLE ];
    
    int vcMark = 0;
    self.tabBar.tintColor = [UIColor colorWithRed:253/255.0 green:99/255.0 blue:99/255.0 alpha:1];
    NSArray *title = @[@"首页",@"主题馆",@"我的"];
    NSArray *img = @[@"ic_main_tab_home",@"ic_main_tab_community",@"ic_main_tab_personal"];
    NSArray *select = @[@"ic_main_tab_home_checked",@"ic_main_tab_community_checked",@"ic_main_tab_personal_checked"];
    for (UINavigationController *vc in self.viewControllers) {
        UIImage *image = [UIImage imageNamed:img[vcMark]];
        UIImage *selected = [UIImage imageNamed:select[vcMark]];
        //修改图片大小
        image = [UIImage reSizeImage:image toSize:CGSizeMake(30, 30)];
        selected = [UIImage reSizeImage:selected toSize:CGSizeMake(30, 30)];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        selected = [selected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title[vcMark] image:image selectedImage:selected];
//        vc.title = title[vcMark];
        [vc.viewControllers firstObject].title = title[vcMark];
        vcMark ++;
    }
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
