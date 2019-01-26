//
//  MKFlagShared.h
//  YangDongXi
//
//  Created by Constance Yang on 26/07/2015.
//  Copyright (c) 2015 yangdongxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKFlagShared : NSObject

+(instancetype)sharedInstance;

@property (strong,nonatomic) NSMutableDictionary *flagDictionary;

@property (strong,nonatomic) NSMutableDictionary *imageHeightDictionary;
@property (strong,nonatomic)NSMutableDictionary * GirdHeightDictionary;

@property (copy ,nonatomic)NSString * tittleName;


@end
