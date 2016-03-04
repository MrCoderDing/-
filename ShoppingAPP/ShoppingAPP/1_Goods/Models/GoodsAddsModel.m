//
//  GoodsAddsModel.m
//  ShoppingAPP
//
//  Created by qianfeng on 16/1/26.
//  Copyright (c) 2016年 JC. All rights reserved.
//

#import "GoodsAddsModel.h"
#import "MJExtension.h"
#import "Network.h"
@implementation GoodsAddsDataModel
+(NSDictionary *)mj_objectClassInArray{
    NSDictionary *dic = @{@"data":@"AdvModel"};
    return dic;
}
+(void)arrayOfGoodsAddsModels:(void(^)(NSArray *arrayOfModels))arrayblock{
    Network *network =[Network shareData];
    [network GET:ADS_API parameters:nil success:^(id responseObject) {
        GoodsAddsDataModel *data = [[GoodsAddsDataModel alloc]mj_setKeyValues:responseObject];
        arrayblock(data.data);
    } failure:^(NSError *error) {
        arrayblock(nil);
    }];
}
@end
@implementation AdvModel



@end