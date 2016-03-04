//
//  TopicModel.m
//  ShoppingAPP
//
//  Created by qianfeng on 16/2/16.
//  Copyright (c) 2016年 JC. All rights reserved.
//

#import "TopicModel.h"
#import "MJExtension.h"
#import "Network.h"

@implementation TopicModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    NSDictionary *dic = @{@"topics":@"data"};
    return dic;
}
+(NSDictionary *)mj_objectClassInArray{
    NSDictionary *dic = @{@"topics":@"Topic"};
    return dic;
}

+ (void)arrayWithTopicModels:(void(^)(NSArray *models))arrayblock bytabId:(NSNumber *)tabID{
    Network *manager = [Network shareData];
    NSString *url = [NSString stringWithFormat:SHOPPING_API,tabID];
    [manager GET:url parameters:nil success:^(id responseObject) {
        TopicModel *model = [[TopicModel alloc]mj_setKeyValues:responseObject];
        if (arrayblock) {
            arrayblock(model.topics);
        }
    } failure:^(NSError *error) {
        if (arrayblock) {
            arrayblock(nil);
        }
    }];
}
@end
@implementation Topic

@end