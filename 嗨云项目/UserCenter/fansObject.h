//
//  fansObject.h
//  嗨云项目
//
//  Created by 小辉 on 16/9/6.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKBaseObject.h"

@interface fansObject : MKBaseObject
//收益
@property(nonatomic,assign)NSInteger cumMoney;
//日期
@property (nonatomic,copy)NSString*gmtCreated;
//头像
@property (nonatomic,copy)NSString *headPortrait;
//昵称
@property(nonatomic,copy)NSString*nickName;
//性别
@property (nonatomic,assign)NSInteger sex;
//userID
@property (nonatomic,copy)NSString*userID;
@end
