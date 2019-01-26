//
//  MKCommentObject.h
//  YangDongXi
//
//  Created by cocoa on 15/4/16.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKBaseLib.h"

@interface MKCommentObject : MKBaseObject

/**@brief 商品评论uid*/
@property (nonatomic, strong) NSString *commentUid;

/**@brief 用户id*/
@property (nonatomic, assign) NSInteger userId;

/**@brief 用户昵称*/
@property (nonatomic, strong) NSString *userName;

/**@brief 订单uid*/
@property (nonatomic, strong) NSString *orderUid;

/**@brief 商品id*/
@property (nonatomic, strong) NSString *itemUid;

/**@brief 供应商id*/
@property (nonatomic, assign) NSInteger supplierId;

/**@brief 评论标题*/
@property (nonatomic, strong) NSString *title;

/**@brief 评论内容*/
@property (nonatomic, strong) NSString *content;

/**@brief 评论时间*/
@property (nonatomic, strong) NSString *commentTime;

/**@brief 回复内容*/
@property (nonatomic, strong) NSString *replyContent;

/**@brief 回复者用户id*/
@property (nonatomic, assign) NSInteger replyUserId;

/**@brief 回复时间*/
@property (nonatomic, strong) NSString *replyTime;

@end
