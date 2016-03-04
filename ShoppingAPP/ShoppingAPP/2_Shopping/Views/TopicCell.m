//
//  TopicCell.m
//  ShoppingAPP
//
//  Created by qianfeng on 16/2/16.
//  Copyright (c) 2016年 JC. All rights reserved.
//

#import "TopicCell.h"
#import "UIImageView+WebCache.h"

@interface TopicCell()
{
    UIImageView *_imgView;
}
@end
@implementation TopicCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE_WIDTH, SCREEN_SIZE_WIDTH/2.0)];
        [self addSubview:_imgView];
    }
    return self;
}
- (void)awakeFromNib {
    
    NSLog(@"awake");
}
-(void)loadData:(Topic *)model{
    //加载网络图片
     [_imgView setImageWithURL:[NSURL URLWithString:model.bannerUrl]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
