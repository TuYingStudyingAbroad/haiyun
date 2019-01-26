//
//  MKNagavitionBarObject.h
//  YangDongXi
//
//  Created by 李景 on 16/3/4.
//  Copyright © 2016年 yangdongxi. All rights reserved.
//

#import "MKBaseLib.h"

@interface MKNagavitionBarObject : MKBaseObject

@property (nonatomic, strong) NSString *tabbarName;
@property (nonatomic, strong) NSString *iconSelected;
@property (nonatomic, strong) NSString *iconUnselected;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, assign) NSInteger isDefault;
@end
