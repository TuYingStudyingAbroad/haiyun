//
//  MKGridBlockList.h
//  嗨云项目
//
//  Created by 小辉 on 16/11/24.
//  Copyright © 2016年 haiyun. All rights reserved.
//

#import "MKBaseObject.h"

@interface MKGridBlockList : MKBaseObject

@property (nonatomic,copy)NSString *leftTopX;
@property (nonatomic,copy)NSString *leftTopY;
@property (nonatomic,copy)NSString *bottomRightX;
@property (nonatomic,copy)NSString *bottomRightY;
@property (strong,nonatomic) NSString *targetUrl;
@property (strong,nonatomic) NSString *imageUrl;
    
@end
