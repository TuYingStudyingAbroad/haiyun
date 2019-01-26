//
//  MKUserModel.h
//  MKBaseLib
//
//  Created by cocoa on 15/3/27.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKBaseLib.h"

@interface MKUserModel : MKBaseObject

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, strong) NSString *token;

@end
