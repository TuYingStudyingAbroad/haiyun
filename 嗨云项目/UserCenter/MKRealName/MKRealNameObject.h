//
//  MKRealNameObject.h
//  YangDongXi
//
//  Created by windy on 15/5/18.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKBaseLib.h"

@interface MKRealNameObject : MKBaseObject

/**@brief 真实姓名*/
@property (nonatomic, strong) NSString *realName;

/**@brief 身份证号*/
@property (nonatomic, strong) NSString *idCard;

/**@brief 身份证正面照片存储地址*/
@property (nonatomic, strong) NSString *frontImage;

/**@brief 身份证反面照片存储地址*/
@property (nonatomic, strong) NSString *reverseImage;

@end
