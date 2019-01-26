//
//  YLPersionNewsViewController.h
//  嗨云项目
//
//  Created by YanLu on 16/5/12.
//  Copyright © 2016年 杨鑫. All rights reserved.
//
/**
 完善信息
 */
typedef enum
{
    HYNewsAll,//所有的信息（手机，密码，邀请码）0
    HYNewsPhoneNumAndPassword,//手机和密码 1
    HYNewsPhoneNumAndInviteCode,//手机和邀请码 2
    HYNewsPhoneNum,//手机号码，绑定  3
    HYNewsIniteCodeAndPassword,//邀请码和密码 4
    HYNewsPassword,//密码  5
    HYNewsInviteCode,//邀请码  6
    
}HYPersionNewsType;

#import "HYBaseViewController.h"

@interface YLPersionNewsViewController : HYBaseViewController

@property(nonatomic) HYPersionNewsType persionNewsType;

@end
