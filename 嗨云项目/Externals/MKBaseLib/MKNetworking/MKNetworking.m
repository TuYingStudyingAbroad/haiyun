//
//  MKNetworking.m
//  MKBaseLib
//
//  Created by cocoa on 15/3/25.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKNetworking.h"
#import "NSData+MKBaseLib.h"
#import "UIApplication+MKBaseLib.h"
#import "NSString+MKBaseLib.h"
#import "MKBaseAppConfig.h"

#define HTTP_REQUEST_TIMEOUTINTERVAL 20
#define MKLog(...) if (hasLog) NSLog(__VA_ARGS__)

static NSString *baseUrl = @"http://127.0.0.1";
static NSString *appVer = @"1.0";
static NSString *appKey = @"";
static NSString *appSecret = @"";

static NSOperationQueue *que;

static BOOL hasLog = NO;

@implementation MKNetworking

/**
 @brief 打开日志，日志默认是关闭的
 */
+ (void)enableLog
{
    hasLog = YES;
}

/**
 @brief 设置url主路径
 @param baseUrlr     默认http://127.0.0.1
 */
+ (void)setBaseUrl:(NSString *)url
{
    baseUrl = url;
    while ((baseUrl.length > 0 && [[baseUrl substringFromIndex:baseUrl.length - 1] isEqualToString:@"/"]))
    {
        baseUrl = [baseUrl substringToIndex:baseUrl.length - 1];
    }
}

/**
 @brief 获取url主路径
 @param baseUrlr     默认http://127.0.0.1
 */
+ (NSString *)getBaseUrl
{
    return baseUrl;
}

/**
 @brief 获取url主路径
 @param BaseHtmlURL     默认http://127.0.0.1
 */
+ (NSString *)getBaseHtmlURL
{
    if ( [baseUrl isEqualToString:@"http://apibeta.haiyn.com"] ) {
        return @"http://mbeta.haiyn.com";
    }else if ( [baseUrl isEqualToString:@"http://apitest.haiyn.com"] )
    {
        return  @"http://mtest.haiyn.com";
    }
    return @"http://m.haiyn.com";
}
/**
 @brief 设置应用版本，通用参数用到
 @param ver     默认1.0
 */
+ (void)setAppVer:(NSString *)ver
{
    appVer = ver;
}

/**
 @brief 设置客户标示
 @param key     默认空
 */
+ (void)setAppKey:(NSString *)key
{
    appKey = key;
}

/**
 @brief 设置签名key
 @param secret     默认空
 */
+ (void)setAppSecret:(NSString *)secret
{
    appSecret = secret;
}

/**
 @brief API POST，会对参数进行签名
 @param api         api名
 @param paramters   POST参数放在这里，参数都会经过urlEncode，所以外面不需要urlEncode了
 @param completion  完成回调
 @discussion        这个方法会拼接通用参数，然后再签名
 */
+ (void)MKPOSTAPI:(NSString *)api paramters:(NSDictionary *)paramters
       completion:(void (^)(MKHttpResponse *response))completion
{
    NSMutableString *url = [NSMutableString stringWithString:[self buildUrlWithApi:api]];
    [self MKPOSTUrl:url paramters:paramters completion:completion];
}

/**
 @brief 这个使用默认的基本格式拼接url，然后发起请求
 @param api         api名
 @param paramters   参数放在这里，参数都会经过urlEncode，所以外面不需要urlEncode了
 @param completion  完成回调
 @discussion        这个方法会拼接通用参数，然后再签名
 */
+ (void)MKGETAPI:(NSString *)api paramters:(NSDictionary *)paramters completion:(void (^)(MKHttpResponse *response))completion
{
    NSString *url = [self buildUrlWithApi:api andParamters:paramters];
    MKLog(@"MKNetworking GET == %@", url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.timeoutInterval = HTTP_REQUEST_TIMEOUTINTERVAL;
    [self sendRequest:request completion:completion];
}

/**
 @brief 这个使用默认的基本格式拼接url，然后POST请求
 @param api         api名
 @param formObj     POST数据放这里面
 @param paramters   GET参数放在这里，参数都会经过urlEncode，所以外面不需要urlEncode了
 @param completion  完成回调
 @discussion        这个方法会拼接通用参数，然后再签名
 */
+ (void)MKPOSTAPI:(NSString *)api withForm:(MKMulipartFormObject *)formObj
     andParamters:(NSDictionary *)paramters completion:(void (^)(MKHttpResponse *response))completion
{
    NSString *url = [self buildUrlWithApi:api andParamters:paramters];
    MKLog(@"MKNetworking MulipartForm POST == %@", url);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]
                                                                cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                            timeoutInterval:HTTP_REQUEST_TIMEOUTINTERVAL];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data;boundary=%@", formObj.boundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    if (!formObj.isEndBuild)
    {
        [formObj endBuild];
    }
    request.HTTPBody = formObj.buildingData;
    
    [self sendRequest:request completion:completion];
}

/**
 @brief 拼接默认参数然后签名，然后发起请求
 @param url         请求地址，这里不能带参数，否则签名会失败
 @param paramters   参数放在这里，参数都会经过urlEncode，所以外面不需要urlEncode了
 @param completion  完成回调
 */

+ (void)MKGETUrl:(NSString *)url paramters:(NSDictionary *)paramters completion:(void (^)(MKHttpResponse *response))completion
{
    url = [self buildUrl:url withParamters:paramters];
    MKLog(@"MKNetworking GET == %@", url);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.timeoutInterval = HTTP_REQUEST_TIMEOUTINTERVAL;
    [self sendRequest:request completion:completion];
}

/**
 @brief 会添加默认参数和签名，然后发起请求
 @param url         请求地址，这个后面的参数不会被签名
 @param paramters   POST参数放在这里
 @param completion  完成回调
 */
+ (void)MKPOSTUrl:(NSString *)url paramters:(NSDictionary *)paramters
       completion:(void (^)(MKHttpResponse *response))completion
{
    NSMutableDictionary *p = [self disposeParamters:paramters];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]
                                                                cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                            timeoutInterval:HTTP_REQUEST_TIMEOUTINTERVAL];
    [request setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod = @"POST";
    NSString *paramtersString = [self assembleParamters:p];
    [request setHTTPBody:[paramtersString dataUsingEncoding:NSUTF8StringEncoding]];
    
    MKLog(@"MKNetworking POST == %@, paramters == %@", url, paramtersString);
    
    [self sendRequest:request completion:completion];
}

/**
 @brief 基本GET请求
 */
+ (void)GET:(NSString *)urlString completion:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError))completion
{
    MKLog(@"MKNetworking GET == %@", urlString);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [[UIApplication sharedApplication] baseLib_toggleNetworkActivityIndicatorVisible:YES];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        [[UIApplication sharedApplication] baseLib_toggleNetworkActivityIndicatorVisible:NO];
        if (completion)
        {
            completion(response, data, connectionError);
        }
    }];
}

/**
 @brief 基本POST请求，没用任何规则，就是普通的http请求
 */
+ (void)POST:(NSString *)urlString form:(MKMulipartFormObject *)formObj
  completion:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError))completion
{
    que = [NSOperationQueue mainQueue];
    MKLog(@"MKNetworking POST == %@", urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]
                                                                cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                            timeoutInterval:HTTP_REQUEST_TIMEOUTINTERVAL];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data;boundary=%@", formObj.boundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    if (!formObj.isEndBuild)
    {
        [formObj endBuild];
    }
    request.HTTPBody = formObj.buildingData;
    
    [[UIApplication sharedApplication] baseLib_toggleNetworkActivityIndicatorVisible:YES];
    [NSURLConnection sendAsynchronousRequest:request queue:que
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        [[UIApplication sharedApplication] baseLib_toggleNetworkActivityIndicatorVisible:NO];
        if (completion)
        {
            completion(response, data, connectionError);
        }
    }];
}

#pragma mark - 内部方法

+ (void)sendRequest:(NSURLRequest *)request
         completion:(void (^)(MKHttpResponse *response))completion
{
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        [self filterError:data connectionError:connectionError completion:completion];
    }];
}

+ (void)filterError:(NSData *)data connectionError:(NSError *)connectionError
     completion:(void (^)(MKHttpResponse *response))completion
{
    if (completion == nil)
    {
        return ;
    }
    MKHttpResponse *res = [[MKHttpResponse alloc] init];
    res.connectionError = connectionError;
    res.originData = data;
    if (connectionError != nil || data == nil )
    {
        res.errorMsg = @"请检查网络是否开启!";
        res.errorType = MKHttpErrorTypeLocal;
        completion(res);
        return;
    }
    
    NSDictionary *responseObject = [data baseLib_jsonObject];
    if ( [responseObject isKindOfClass:[NSDictionary class]] )
    {
        NSString *msg = [responseObject HYValueForKey:@"msg"];
        res.responseCode = [[responseObject HYValueForKey:@"code"] integerValue];
        //将10000定义为成功了
        if (res.responseCode != 10000)
        {
            if (msg.length == 0 || (res.responseCode >= 40000 && res.responseCode < 50000))
            {
                msg = @"服务器开小差儿了~";
            }
            res.errorMsg = msg;
            res.errorType = MKHttpErrorTypeRemote;
            completion(res);
            return;
        }
        
        res.responseDictionary = responseObject;
        completion(res);
 
    }else
    {
        res.errorMsg = @"请检查网络是否开启!";
        res.errorType = MKHttpErrorTypeLocal;
        completion(res);
        return;
    }
}

+ (NSString *)buildUrlWithApi:(NSString *)api andParamters:(NSDictionary *)paramters
{
    return [self buildUrl:[self buildUrlWithApi:api] withParamters:paramters];
}

+ (NSString *)buildUrl:(NSString *)uri withParamters:(NSDictionary *)paramters
{
    NSMutableDictionary *p = [self disposeParamters:paramters];
    
    NSMutableString *url = [NSMutableString stringWithString:uri];
    [url appendString:@"?"];
    [url appendString:[self assembleParamters:p]];
    
    return url;
}

+ (NSString *)assembleParamters:(NSDictionary *)paramters
{
    NSMutableString *s = [NSMutableString string];
    [paramters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
    {
        key = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        obj = [obj stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [s appendFormat:@"&%@=%@", key, obj];
    }];
    [s deleteCharactersInRange:NSMakeRange(0, 1)];
    return [s copy];
}

+ (NSMutableDictionary *)disposeParamters:(NSDictionary *)paramters
{
    NSMutableDictionary *p = [NSMutableDictionary dictionaryWithCapacity:paramters.count];
    
    [paramters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
    {
        if (![key isKindOfClass:[NSString class]])
        {
            key = [NSString stringWithFormat:@"%@", key];
        }
        key = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (![obj isKindOfClass:[NSString class]])
        {
            obj = [NSString stringWithFormat:@"%@", obj];
        }
        p[key] = obj;
    }];
    
    p[@"app_key"] = appKey;
    p[@"version"] = IosAppVersion;
    p[@"device_id"] = [MKBaseAppConfig MKUDID];
    p[@"format"] = @"json";
    NSArray *a = [p.allKeys sortedArrayUsingSelector:@selector(compare:)];
    NSMutableString *s = [NSMutableString string];
    for (NSString *k in a)
    {
        [s appendFormat:@"&%@=%@", k, p[k]];
    }
    [s deleteCharactersInRange:NSMakeRange(0, 1)];
    NSString *ss = [NSString stringWithFormat:@"%@%@%@", appSecret, s, appSecret];
    
    p[@"api_sign"] = [ss baseLib_md5String];
    return p;
}

+ (NSString *)buildUrlWithApi:(NSString *)api
{
    NSString *na = api;
    while (na.length > 0 && [[na substringToIndex:1] isEqualToString:@"/"])
    {
        na = [na substringFromIndex:1];
    }
    if (na.length == 0)
    {
        return baseUrl;
    }
    return [baseUrl stringByAppendingFormat:@"/%@", na];
}
+ (void)cancelAllOperation{
    [que cancelAllOperations];
}

@end
