

#import <Foundation/Foundation.h>

@class AFNetworking;
@interface Network : NSObject


/**
 *  创建单例
 */
+ (instancetype)shareData;

/**
 *  向服务器发送get请求
 *
 *  @param url     请求的接口
 *  @param parameter 向服务器请求数据时候的参数
 *  @param success 请求成功结果,block的参数为服务器返回的数据
 *  @param failuer 请求失败,block的参数是错误的信息
 */
- (void)GET:(NSString *)url parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 *  带请求头的get请求
 *
 *  @param url     请求的接口
 *  @param head    请求头
 *  @param parameter 向服务器请求数据时候的参数
 *  @param success 请求成功结果,block的参数为服务器返回的数据
 *  @param failuer 请求失败,block的参数是错误的信息
 */
- (void)GET:(NSString *)url parameters:(id)parameters urlHead:(NSDictionary *)head success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;


/**
 *  向服务器post数据
 *
 *  @param url       要提交数据额结构
 *  @param parameter 要提交的数据
 *  @param success   成功执行的block,block的参数为服务器返回的内容
 *  @param failure   失败执行的block,block的参数为错误信息
 */
- (void)POST:(NSString *)url parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 *  向服务器上传文件
 *
 *  @param url       要上传文件的接口
 *  @param parameter 上传的参数
 *  @param fileData  上传的文件数据
 *  @param name      服务所对应的字段
 *  @param fileName  上传到服务器的文件名
 *  @param mimeType  上传文件类型
 *  @param success   成功执行的block,block的参数为服务器返回的内容
 *  @param failure   失败执行的block,block的参数为错误信息
 */
- (void)Post:(NSString *)url
   parameter:(NSDictionary *)parameter
        data:(NSData *)fileData
        name:(NSString *)name
    fileName:(NSString *)fileName
    mimeType:(NSString *)mimeType
     success:(void(^)(id responseObject))success
     failure:(void(^)(NSError *error))failure;


@end