//
//  HYAgreementObject.h
//  嗨云项目
//
//  Created by haiyun on 2016/10/25.
//  Copyright © 2016年 haiyun. All rights reserved.
//

#import "MKBaseObject.h"

@interface HYAgreementObject : MKBaseObject

@property (nonatomic,copy) NSString *Id;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *proName;//协议名称

@property (nonatomic,copy) NSString  *proContent;//协议内容

@property (nonatomic,copy) NSString  *proModel;//协议内容


@end
