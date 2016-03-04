//
//  GoodsCollectionViewCell.h
//  ShoppingAPP
//
//  Created by qianfeng on 16/1/22.
//  Copyright (c) 2016年 JC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *nowPrice;
@property (weak, nonatomic) IBOutlet UILabel *oldPrice;
@property (weak, nonatomic) IBOutlet UILabel *dealnum;

@end
