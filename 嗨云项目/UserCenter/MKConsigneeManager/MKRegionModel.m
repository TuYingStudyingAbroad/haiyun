//
//  MKRegionModel.m
//  YangDongXi
//
//  Created by cocoa on 15/4/7.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKRegionModel.h"
#import "MKRegionItem.h"
#import "MKNetworking+BusinessExtension.h"

@interface MKRegionModel ()
{
    
}

@end


@implementation MKRegionModel


+(void)firstAddressWithCode1:(NSString *)pcode
                    cityCode:(NSString *)ccode
                    areaCode:(NSString *)acode
                  completion:(void (^)(NSString *address))completion;
{
    __weak typeof(self) weakSelf = self;
    [self getAddressWithCode:@"CN" completion:^{
        
        [weakSelf getAddressWithCode:pcode completion:^{
            
            [weakSelf getAddressWithCode:ccode completion:^{
                
                NSArray *dataArray = [weakSelf readArrayWithCustomObjFromUserDefaults:@"CN"];
                NSString *provinceName = @"";
                if ( dataArray && dataArray.count > 0 )
                {
                    for(MKRegionItem *item in dataArray )
                    {
                        if ( [item.code isEqual:pcode] )
                        {
                            provinceName = item.name;
                            break;
                        }
                    }
                }
                NSArray *dataArray1 = [weakSelf readArrayWithCustomObjFromUserDefaults:pcode];
                NSString *cityName = @"";
                if ( dataArray1 && dataArray1.count > 0 )
                {
                    for(MKRegionItem *item in dataArray1 )
                    {
                        if ( [item.code isEqual:ccode] )
                        {
                            cityName = item.name;
                            break;
                        }
                    }
                    
                }
                NSArray *dataArray2 = [weakSelf readArrayWithCustomObjFromUserDefaults:ccode];
                NSString *areaName = @"";
                if ( dataArray2 && dataArray2.count > 0 )
                {
                    for(MKRegionItem *item in dataArray2 )
                    {
                        if ( [item.code isEqual:acode] )
                        {
                            areaName = item.name;
                            break;
                        }
                    }
                    
                }
                if ( completion )
                {
                    completion([NSString stringWithFormat:@"%@%@%@",provinceName,cityName,areaName]);
                }
            }];
        }];
    }];
   
}
#pragma mark -- get data

+(NSArray *)readArrayWithCustomObjFromUserDefaults:(NSString*)keyName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(!keyName || keyName.length  == 0)
    {
        return nil;
    }
    
    NSData *data = [defaults objectForKey:keyName];
    
    if(data)
    {
        NSArray *myArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        return myArray;
    }
    else
    {
        return nil;
    }
}

#pragma mark -- save data

+(void)writeArrayWithCustomObjToUserDefaults:(NSString *)keyName withArray:(NSMutableArray *)myArray
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:myArray];
    
    [defaults setObject:data forKey:keyName];
    
    [defaults synchronize];
}

+(void)getAddressWithCode:(NSString *)code  completion:(void(^)(void))completion;
{
    NSArray *dataArray = [self readArrayWithCustomObjFromUserDefaults:code];
    
    if(dataArray && dataArray.count > 0)
    {
        if(completion)
        {
            completion();
        }
    }
    else
    {
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"region_code": code}];
        
        [MKNetworking MKSeniorGetApi:@"/delivery/sub_region/list" paramters:param completion:^(MKHttpResponse *response)
         {
             NSArray *db = [response mkResponseData][@"region_list"];
             
             NSMutableArray *tempArray = [[NSMutableArray alloc]init];
             
             for (NSDictionary *d in db)
             {
                 MKRegionItem *item = [[MKRegionItem alloc]init];
                 
                 item.code = [d objectForKey:@"code"];
                 
                 item.name = [d objectForKey:@"name"];
                 
                 item.pcode = [d objectForKey:@"id"];
                 
                 [tempArray addObject:item];
             }
             
             if(tempArray.count > 0)
             {
                 [self writeArrayWithCustomObjToUserDefaults:code withArray:tempArray];
             }
             else
             {
                 MKRegionItem *item = [[MKRegionItem alloc]init];
                 
                 item.code = @"NOCODE";
                 
                 item.name = @"我不清楚";
                 
                 [tempArray addObject:item];
             }
             
            
             if(completion)
             {
                 completion();
             }
             
         }];
    }
}

@end
