//
//  MKDistributorInfo.h
//  嗨云项目
//
//  Created by 杨鑫 on 16/5/10.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKBaseObject.h"

@interface MKDistributorInfo : MKBaseObject
//分销商id
@property (nonatomic,strong)NSString *distributorId;
//分销商店铺名
@property (nonatomic,strong)NSString *shopName;
//店铺签名
@property (nonatomic,strong)NSString *distributorSign;
//店铺头像
@property (nonatomic, strong) NSString *headImgUrl;
@end
