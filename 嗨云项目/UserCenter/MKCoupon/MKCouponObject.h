//
//  MKCouponObject.h
//  YangDongXi
//
//  Created by windy on 15/4/24.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKBaseLib.h"


@interface MKCouponObject : MKBaseObject

/**@brief 优惠券id*/
@property (nonatomic,strong) NSString *couponUid;
/**@brief 优惠券名称*/
@property (nonatomic,strong) NSString *toolCode;
/**@brief 优惠内容*/
@property (nonatomic,assign) NSInteger discountAmount;
///**@brief 优惠券的状态：0代表未使用，1代表冻结中，2代表已使用*/
//@property (nonatomic,assign) NSInteger status;
/**@brief 优惠活动开始时间*/
@property (nonatomic,strong) NSString *startTime;
/**@brief 优惠活动结束时间*/
@property (nonatomic,strong) NSString *endTime;
/**@brief 优惠张数*/
@property (nonatomic,assign) NSInteger number;

@property (nonatomic,assign) NSInteger scope;

/**@brief 3:全店 4:指定商品 */
@property (nonatomic,strong) NSArray * propertyList;

/**@brief 优惠券名称*/
@property (nonatomic,strong) NSString * name;

/**@brief 优惠条件*/
@property (nonatomic,strong) NSString * content;

//@"propertyList" :@"property_list",
//如：NSDictionary中的key为productId，对应类属性名pId;


////////王新辉新加
@property (nonatomic,assign)BOOL ischos;
@property (nonatomic,assign)NSInteger nearExpireDate;

@end
