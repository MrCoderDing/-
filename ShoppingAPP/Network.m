

#import "Network.h"
#import "AFNetworking.h"

@implementation Network

//单例
+ (instancetype)shareData{
    static Network *network = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (network == nil) {
            network = [[Network alloc] init];
        }
    });
    return network;
}

//GET数据请求
- (void)GET:(NSString *)url parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *mainDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if (success) {
            success(mainDict);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
 
}

//GET数据请求 带请求头
- (void)GET:(NSString *)url parameters:(id)parameters urlHead:(NSDictionary *)head success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:[head allValues][0] forHTTPHeaderField:[head allKeys][0]];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *mainDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if (success) {
            success(mainDict);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}



//POST数据请求
- (void)POST:(NSString *)url parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];

}

//提交文件
- (void)Post:(NSString *)url parameter:(NSDictionary *)parameter data:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        
    }];
}



@end
