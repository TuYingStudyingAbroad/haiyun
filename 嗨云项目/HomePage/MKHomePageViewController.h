//
//  MKHomePageViewController.h
//  YangDongXi
//
//  Created by cocoa on 15/4/7.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THSegmentedPager.h"

@interface MKHomePageViewController : UIViewController



@property (nonatomic,strong)NSString *sellerId;

@property (nonatomic,assign)BOOL isGoinHome;

@property (nonatomic,strong)NSString *isgoinhome;
- (void)closeSearchView;

@end
