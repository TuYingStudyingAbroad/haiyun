//
//  PersonalInfo.h
//  嗨云项目
//
//  Created by 小辉 on 16/6/7.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalInfo : NSObject
@property (copy, nonatomic) NSString* nameStr;
+(PersonalInfo*)sharedModel;
@end
