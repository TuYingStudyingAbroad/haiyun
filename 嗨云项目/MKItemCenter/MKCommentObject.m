//
//  MKCommentObject.m
//  YangDongXi
//
//  Created by cocoa on 15/4/16.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKCommentObject.h"

@implementation MKCommentObject

+ (NSDictionary *)propertyAndKeyMap
{
    return @{@"commentUid" : @"comment_uid",
             @"userId" : @"user_id",
             @"userName" : @"user_name",
             @"orderUid" : @"order_uid",
             @"itemUid" : @"item_uid",
             @"supplierId" : @"supplier_id",
             @"commentTime" : @"comment_time",
             @"replyContent" : @"reply_content",
             @"replyUserId" : @"reply_user_id",
             @"replyTime" : @"reply_time"
             };
}

@end
