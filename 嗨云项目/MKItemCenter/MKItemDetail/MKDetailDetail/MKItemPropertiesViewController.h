//
//  MKItemPropertiesViewController.h
//  YangDongXi
//
//  Created by cocoa on 15/6/1.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKDetailDetailSubViewControllerDelegate.h"

@interface MKItemPropertiesViewController : UIViewController <MKDetailDetailSubViewControllerProtocol>

@property (nonatomic, weak) id<MKDetailDetailSubViewControllerDelegate> delegate;

- (void)loadProperties:(NSArray *)properties;

@end
