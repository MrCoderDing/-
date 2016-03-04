//
//  BaseTableViewController.h
//  ShoppingAPP
//
//  Created by qianfeng on 16/2/16.
//  Copyright (c) 2016年 JC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewController : UITableViewController
@property(nonatomic,strong)NSNumber *tabID;
-(void)loadDataBy:(NSNumber *)tabID;
//@property(nonatomic,strong)UIViewController *ContViewController;
@end
