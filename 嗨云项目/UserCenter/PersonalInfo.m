
//
//  PersonalInfo.m
//  嗨云项目
//
//  Created by 小辉 on 16/6/7.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "PersonalInfo.h"

@implementation PersonalInfo

static PersonalInfo *personalInfo = nil;


+(PersonalInfo *)sharedModel {
    if (personalInfo==nil) {
        personalInfo=[[PersonalInfo alloc]init];
        
    }
    
    return personalInfo;
    
}

-(id)init
{
    if (self = [super init]) {
        self.nameStr = [[NSString alloc] init];
    }
    return self;
}
@end
