//
//  MKMulipartFormObject.m
//  MKBaseLib
//
//  Created by cocoa on 15/3/18.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKMulipartFormObject.h"

@implementation MKMulipartFormObject

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _boundary = [NSString stringWithFormat:@"MKBoundary+%08X%08X", arc4random(), arc4random()];
        _buildingData = [NSMutableData data];
    }
    return self;
}

- (void)addParameters:(NSDictionary *)parameters;
{
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
         [self.buildingData appendData:[[NSString stringWithFormat:@"--%@\r\n", self.boundary] dataUsingEncoding:NSUTF8StringEncoding]];
         [self.buildingData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n", key, obj]
                                        dataUsingEncoding:NSUTF8StringEncoding]];
     }];
}

- (void)addJPGData:(NSData *)file withName:(NSString *)name
{
    [self addFileData:file withName:name type:@"image/jpg" filename:name];
}

- (void)addFileData:(NSData *)file withName:(NSString *)name type:(NSString *)type filename:(NSString *)filename
{
    [self.buildingData appendData:[[NSString stringWithFormat:@"--%@\r\n", self.boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    if (filename.length == 0)
    {
        filename = name;
    }
    NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",
                             name, filename];
    [self.buildingData appendData:[disposition dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *contentType = [NSString stringWithFormat:@"Content-Type: %@\r\n\r\n",type];
    [self.buildingData appendData:[contentType dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self.buildingData appendData:file];
    [self.buildingData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)endBuild;
{
    NSString *boundary = [NSString stringWithFormat:@"--%@--\r\n", self.boundary];
    [self.buildingData appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
    _isEndBuild = YES;
}

@end
