//
//  GoodsAddsModel.h
//  ShoppingAPP
//
//  Created by qianfeng on 16/1/26.
//  Copyright (c) 2016年 JC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsAddsDataModel : NSObject

@property(nonatomic,copy)NSArray * data;
+(void)arrayOfGoodsAddsModels:(void(^)(NSArray *arrayOfModels))arrayblock;
@end

@interface AdvModel : NSObject
@property (nonatomic, copy) NSString *target;
@property (nonatomic, copy) NSString *ipadimg;
@property (nonatomic, copy) NSString *iphoneimg;
@property (nonatomic, copy) NSString *iphonezimg;
@property (nonatomic, copy) NSString *iphonemimg;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *ipadzimg;
@property (nonatomic, copy) NSString *iphoneimgnew;
@end