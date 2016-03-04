//
//  GoodsModel.h
//  ShoppingAPP
//
//  Created by qianfeng on 16/1/22.
//  Copyright (c) 2016年 JC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ModelArray)(NSArray *array);
@interface GoodsModel : NSObject
@property (nonatomic, strong) NSNumber *discount;
@property (nonatomic, copy) NSString *item_url;
@property (nonatomic, strong) NSNumber *rp_quantity;
@property (nonatomic, copy) NSString *start_discount;
@property (nonatomic, copy) NSString *num_iid;
@property (nonatomic, copy) NSString *show_time;
@property (nonatomic, strong) NSNumber *is_vip_price;
@property (nonatomic, strong) NSNumber *is_onsale;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *pic_url;
@property (nonatomic, strong) NSNumber *total_love_number;
@property (nonatomic, copy) NSString *item_urls;
@property (nonatomic, copy) NSString *rp_type;
@property (nonatomic, strong) NSNumber *now_price;
@property (nonatomic, strong) NSNumber *origin_price;
@property (nonatomic, strong) NSNumber *deal_num;
@property (nonatomic, copy) NSString *tagimage;
@property (nonatomic, strong) NSNumber *rp_sold;


//请求数据,得到数据模型数组
+(void)arrayOfGoodsModels:(void(^)(NSArray *arrayOfModels))arrayblock andCid:(NSNumber *)cid andPage:(NSNumber *)page;
@end



@interface GoodsData : NSObject
@property (nonatomic,copy)NSArray *goodModelsArray;
@end