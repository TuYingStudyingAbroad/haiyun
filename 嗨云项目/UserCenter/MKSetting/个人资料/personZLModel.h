//
//  personZLModel.h
//  嗨云项目
//
//  Created by 唯我独尊 on 16/5/26.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKBaseObject.h"

@interface personZLModel : MKBaseObject

//生日
@property (nonatomic,strong)NSString * birthday;
//性别
@property (nonatomic,strong)NSString * sex;
//头像
@property (nonatomic,strong)NSString * img_url;
//昵称
@property (nonatomic,strong)NSString * nickName;
//微信号
@property (nonatomic,strong)NSString * wxNB;
//QQ号
@property (nonatomic,strong)NSString * qqNB;


@end
