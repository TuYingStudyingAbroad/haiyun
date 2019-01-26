//
//  HYSafeBandInfo.h
//  嗨云项目
//
//  Created by haiyun on 16/9/6.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKBaseObject.h"

@interface HYSafeBandInfo : MKBaseObject

@property(nonatomic,copy) NSString *bankRealname;
@property(nonatomic,copy) NSString *bankPersonalId;
@property(nonatomic,copy) NSString *pictureFront;
@property(nonatomic,copy) NSString *pictureBack;
/**
 *  0审核中，1已经成功，2拒绝,
 */
@property(nonatomic,copy) NSString *authonStatus;

@end
