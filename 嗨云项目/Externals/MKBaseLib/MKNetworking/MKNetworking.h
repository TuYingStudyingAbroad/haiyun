//
//  MKNetworking.h
//  MKBaseLib
//
//  Created by cocoa on 15/3/25.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKHttpResponse.h"
#import "MKMulipartFormObject.h"

/**
 @brief 基本格式为：baseUrl/api?参1=值1&参2=值2...
 */
@interface MKNetworking : NSObject<NSURLConnectionDelegate>

/**
 @brief 打开日志，日志默认是关闭的
 */
+ (void)enableLog;

/**
 @brief 设置url主路径
 @param baseUrlr     默认http://127.0.0.1
 */
+ (void)setBaseUrl:(NSString *)baseUrl;

/**
 @brief 获取url主路径
 @param baseUrlr     默认http://127.0.0.1
 */
+ (NSString *)getBaseUrl;

/**
 @brief 获取url主路径
 @param BaseHtmlURL     默认http://127.0.0.1
 */
+ (NSString *)getBaseHtmlURL;

/**
 @brief 设置应用版本，通用参数用到
 @param ver     默认1.0
 */
+ (void)setAppVer:(NSString *)ver;

/**
 @brief 设置客户标示
 @param key     默认空
 */
+ (void)setAppKey:(NSString *)key;

/**
 @brief 设置签名key
 @param secret     默认空
 */
+ (void)setAppSecret:(NSString *)secret;

/**
 @brief 这个使用默认的基本格式拼接url，然后发起请求
 @param api         api名
 @param paramters   参数放在这里，参数都会经过urlEncode，所以外面不需要urlEncode了
 @param completion  完成回调
 @discussion        这个方法会拼接通用参数，然后再签名
 */
+ (void)MKGETAPI:(NSString *)api paramters:(NSDictionary *)paramters completion:(void (^)(MKHttpResponse *response))completion;

/**
 @brief 这个使用默认的基本格式拼接url，然后POST请求
 @param api         api名
 @param formObj     POST数据放这里面
 @param paramters   GET参数放在这里，参数都会经过urlEncode，所以外面不需要urlEncode了
 @param completion  完成回调
 @discussion        这个方法会拼接通用参数，然后再签名
 */
+ (void)MKPOSTAPI:(NSString *)api withForm:(MKMulipartFormObject *)formObj
     andParamters:(NSDictionary *)paramters completion:(void (^)(MKHttpResponse *response))completion;

/**
 @brief API POST请求，会对参数进行签名
 @param api         api名
 @param paramters   POST参数放在这里，参数都会经过urlEncode，所以外面不需要urlEncode了
 @param completion  完成回调
 @discussion        这个方法会拼接通用参数，然后再签名
 */
+ (void)MKPOSTAPI:(NSString *)api paramters:(NSDictionary *)paramters
       completion:(void (^)(MKHttpResponse *response))completion;

/**
 @brief 拼接默认参数然后签名，然后发起请求
 @param url         请求地址，这里不能带参数，否则签名会失败
 @param paramters   参数放在这里，参数都会经过urlEncode，所以外面不需要urlEncode了
 @param completion  完成回调
 */
+ (void)MKGETUrl:(NSString *)url paramters:(NSDictionary *)paramters completion:(void (^)(MKHttpResponse *response))completion;

/**
 @brief 会添加默认参数和签名，然后发起请求
 @param url         请求地址，这个后面的参数不会被签名
 @param paramters   POST参数放在这里
 @param completion  完成回调
 @discussion application/x-www-form-urlencoded类型POST
 */
+ (void)MKPOSTUrl:(NSString *)url paramters:(NSDictionary *)paramters
       completion:(void (^)(MKHttpResponse *response))completion;

/**
 @brief 基本GET请求，没用任何规则，就是普通的http请求
 */
+ (void)GET:(NSString *)urlString completion:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError))completion;

/**
 @brief 基本POST请求，没用任何规则，就是普通的http请求
 */
+ (void)POST:(NSString *)urlString form:(MKMulipartFormObject *)formObj
  completion:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError))completion;

+ (void)cancelAllOperation;
@end
