//
//  MKBaseAppConfig.m
//  MKBaseLib
//
//  Created by cocoa on 15/4/14.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKBaseAppConfig.h"
#import <AdSupport/AdSupport.h>
#import "NSString+MKBaseLib.h"
#import "SSKeychain.h"

static NSString *const configServiceName = @"com.mockuai.baseLib";
static NSString *const configUDIDKey = @"MKUDID";

static NSString *identifer = nil;

@interface MKBaseAppConfig ()

@property (nonatomic, strong) NSString *appVersion;

@property (nonatomic, strong) NSString *buildVersion;

@property (nonatomic, strong) NSString *idfa;

@end


@implementation MKBaseAppConfig

+ (NSString *)MKUDID
{
    //首先直接从内存取
    if (identifer.length > 0)
    {
        return identifer;
    }
    
    //然后从钥匙串取
    identifer = [SSKeychain passwordForService:configServiceName account:configUDIDKey];
    NSString *userDefaultKey = [NSString stringWithFormat:@"%@.%@", configServiceName, configUDIDKey];
    if (identifer.length > 0)
    {
        //在userdefaults中存一份
        [[NSUserDefaults standardUserDefaults] setObject:identifer forKey:userDefaultKey];
        return identifer;
    }
    //再尝试从userdefaults中取，这种情况是钥匙串丢失，但是应用还在，这种情况貌似不会发生哦，先写着好了
    identifer = [[NSUserDefaults standardUserDefaults] objectForKey:userDefaultKey];
    if (identifer.length > 0)
    {
        [SSKeychain setPassword:identifer forService:configServiceName account:configUDIDKey];
        return identifer;
    }
    //上面都没取到就生成一个
    identifer = [[self class] genUDID];
    [[NSUserDefaults standardUserDefaults] setObject:identifer forKey:userDefaultKey];
    [SSKeychain setPassword:identifer forService:configServiceName account:configUDIDKey];
    return identifer;
}

- (NSString *)getAppVersion;
{
    if (self.appVersion == nil)
    {
        self.appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    }
    return self.appVersion;
}

- (NSString *)getBuildVersion;
{
    if (self.buildVersion == nil)
    {
        self.buildVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    }
    return self.buildVersion;
}

- (NSString *)getIdfa
{
    if (self.idfa == nil)
    {
        self.idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }
    return self.idfa;
}

- (CGSize)screenResolution;
{
    return [UIScreen mainScreen].currentMode.size;
}

+ (NSString *)genUDID
{
    long long int tm = [[NSDate date] timeIntervalSince1970] * 1000;
    tm <<= 4;
    long r = arc4random() % 0x10;
    tm |= r;
    
    unsigned char idd[16] = {0};
    for (int i = 5; i >= 0; --i)
    {
        idd[i] = tm & 0xff;
        tm >>= 8;
    }
    for (int i = 5; i < 16; ++i)
    {
        idd[i] = arc4random() % 0x100;
    }
    return [NSString baseLib_hexString:idd withLength:16];
}

@end
