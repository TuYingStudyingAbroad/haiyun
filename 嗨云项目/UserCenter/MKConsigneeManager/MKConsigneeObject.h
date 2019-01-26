//
//  MKConsigneeObject.h
//  YangDongXi
//
//  Created by cocoa on 15/4/16.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKBaseLib.h"

@interface MKConsigneeObject : MKBaseObject

/**@brief 收货地址id*/
@property (nonatomic, strong) NSString *consigneeUid;

/**@brief 用户id*/
@property (nonatomic, assign) NSInteger userId;

/**@brief 国家code*/
@property (nonatomic, strong) NSString *countryCode;

/**@brief 国家*/
@property (nonatomic, strong) NSString *country;

/**@brief 省code*/
@property (nonatomic, strong) NSString *provinceCode;

/**@brief 省*/
@property (nonatomic, strong) NSString *province;

/**@brief 城市code*/
@property (nonatomic, strong) NSString *cityCode;

/**@brief 城市*/
@property (nonatomic, strong) NSString *city;

/**@brief 区code*/
@property (nonatomic, strong) NSString *areaCode;

/**@brief 区*/
@property (nonatomic, strong) NSString *area;

/**@brief 街道code*/
@property (nonatomic, strong) NSString *streetCode;

/**@brief 详细地址*/
@property (nonatomic, strong) NSString *address;

/**@brief 电话号码*/
@property (nonatomic, strong) NSString *phone;

/**@brief 手机号码*/
@property (nonatomic, strong) NSString *mobile;

/**@brief 收货人*/
@property (nonatomic, strong) NSString *consignee;

/**@brief 邮编*/
@property (nonatomic, strong) NSString *zip;

/**@brief 身份证号*/
@property (nonatomic, strong) NSString *idNo;

/**@brief 是否默认*/
@property (nonatomic, assign) BOOL isDefault;

@property (nonatomic, copy) NSString *addresses;

@end
