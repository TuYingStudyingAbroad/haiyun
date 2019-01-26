//
//  MKOrderCommentViewController.h
//  YangDongXi
//
//  Created by cocoa on 15/6/8.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKWebViewController.h"


@class MKOrderCommentViewController;
@protocol MKOrderCommentViewControllerDelegate <NSObject>

- (void)orderCommentViewControllerCommentFinished:(MKOrderCommentViewController *)commentViewController;

@end


@interface MKOrderCommentViewController : MKWebViewController

@property (nonatomic, weak) id<MKOrderCommentViewControllerDelegate> delegate;

@property (nonatomic, strong) NSString *orderUid;

@end
