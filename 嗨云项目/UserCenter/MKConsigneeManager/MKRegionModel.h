//
//  MKRegionModel.h
//  YangDongXi
//
//  Created by cocoa on 15/4/7.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKRegionModel : NSObject



+(void)firstAddressWithCode1:(NSString *)pcode
                    cityCode:(NSString *)ccode
                    areaCode:(NSString *)acode
                  completion:(void (^)(NSString *address))completion;
@end
