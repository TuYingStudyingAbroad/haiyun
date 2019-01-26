//
//  MKDetailWebViewController.h
//  YangDongXi
//
//  Created by cocoa on 15/4/27.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKDetailDetailSubViewControllerDelegate.h"

@interface MKDetailWebViewController : UIViewController<MKDetailDetailSubViewControllerProtocol>

@property (nonatomic, weak) id<MKDetailDetailSubViewControllerDelegate> delegate;

- (void)loadUrl:(NSString *)url;

@end
