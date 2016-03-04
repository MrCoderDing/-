//
//  TopicModel.h
//  ShoppingAPP
//
//  Created by qianfeng on 16/2/16.
//  Copyright (c) 2016年 JC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicModel : NSObject
@property(nonatomic,strong)NSArray *topics;
//根据tabID 得到数据
+ (void)arrayWithTopicModels:(void(^)(NSArray *models))arrayblock bytabId:(NSNumber *)tabID;
@end

@interface Topic : NSObject
@property (nonatomic, copy) NSString *coverForPadUrl;
@property (nonatomic, copy) NSString *bannerUrl;
@property (nonatomic, strong) NSNumber *textBg;
@property (nonatomic, strong) NSNumber *topicContentId;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *backCover;
@property (nonatomic, copy) NSString *bannerUrlForPad;
@property (nonatomic, copy) NSString *introForPad;


@end