//
//  MKFlagShared.m
//  YangDongXi
//
//  Created by Constance Yang on 26/07/2015.
//  Copyright (c) 2015 yangdongxi. All rights reserved.
//

#import "MKFlagShared.h"
#import "MKMarketingFlagObject.h"

@implementation MKFlagShared

#pragma mark --
#pragma mark -- override getter method

-(NSMutableDictionary *)flagDictionary
{
    if(!_flagDictionary)
    {
        _flagDictionary = [[NSMutableDictionary alloc]init];
    }
    
    return _flagDictionary;
}

-(NSMutableDictionary *)imageHeightDictionary
{
    if(!_imageHeightDictionary)
    {
        _imageHeightDictionary = [[NSMutableDictionary alloc]init];
    }
    return _imageHeightDictionary;
}

-(NSMutableDictionary*)GirdHeightDictionary{
    if (!_GirdHeightDictionary) {
        _GirdHeightDictionary=[[NSMutableDictionary alloc]init];
    }
    return _GirdHeightDictionary;
}


+(instancetype)sharedInstance
{
    static MKFlagShared *sharedInstace = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        
        sharedInstace = [[MKFlagShared alloc]init];
        
    });
    
    return sharedInstace;
    
}

@end
