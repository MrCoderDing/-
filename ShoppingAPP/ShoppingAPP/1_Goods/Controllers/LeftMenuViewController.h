//
//  LeftMenuViewController.h
//  ShoppingAPP
//
//  Created by qianfeng on 16/1/25.
//  Copyright (c) 2016年 JC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ICSDrawerController.h"
@interface LeftMenuViewController : UIViewController<ICSDrawerControllerChild, ICSDrawerControllerPresenting,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak) ICSDrawerController *drawer;
@end
