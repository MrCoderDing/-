//
//  GoodsModel.m
//  ShoppingAPP
//
//  Created by qianfeng on 16/1/22.
//  Copyright (c) 2016年 JC. All rights reserved.
//

#import "GoodsModel.h"
#import "MJExtension.h"
#import "Network.h"

@implementation GoodsModel
+(void)arrayOfGoodsModels:(void(^)(NSArray *arrayOfModels))arrayblock andCid:(NSNumber *)cid andPage:(NSNumber *)page{
    Network *network = [Network shareData];
    NSString *url = nil;
    //0 则不分类,非零分类
    if (cid.intValue == 0) {
        url = [NSString stringWithFormat:GOOD_API,page];
    }else{
        url = [NSString stringWithFormat:GOOD_CATEGORY_API,cid,page];
    }
    [network GET:url parameters:nil success:^(id responseObject) {
        NSDictionary *dict  = responseObject;
        GoodsData *data = [[GoodsData alloc] mj_setKeyValues:dict];
        arrayblock(data.goodModelsArray);
    } failure:^(NSError *error) {
        //如果请求失败传回nil
        arrayblock(nil);
    }];
}
@end


@implementation GoodsData
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    NSDictionary *dic = @{@"goodModelsArray":@"list"};
    return dic;
}

+(NSDictionary *)mj_objectClassInArray{
    NSDictionary *dic = @{@"goodModelsArray":@"GoodsModel"};
    return dic;
}

@end
