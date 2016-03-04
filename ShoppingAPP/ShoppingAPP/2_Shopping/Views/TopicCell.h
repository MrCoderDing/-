//
//  TopicCell.h
//  ShoppingAPP
//
//  Created by qianfeng on 16/2/16.
//  Copyright (c) 2016年 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicModel.h"
@interface TopicCell : UITableViewCell
-(void)loadData:(Topic *)model;
//@property(nonatomic,strong)UIImageView *img;
@end
