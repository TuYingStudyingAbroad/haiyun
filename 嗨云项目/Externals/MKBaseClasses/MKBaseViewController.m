//
//  MKBaseViewController.m
//  YangDongXi
//
//  Created by cocoa on 15/4/22.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKBaseViewController.h"
#import "BaiduMobStat.h"


@interface MKBaseViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<UIGestureRecognizerDelegate> systemSwipeBackDelegate;

@property (nonatomic, assign) BOOL systemSwipeBackEnable;

@end


@implementation MKBaseViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
//        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kHEXCOLOR(0xf5f5f5);
}

- (void)awakeFromNib
{
//    self.hidesBottomBarWhenPushed = YES;
    [super awakeFromNib];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)enableSwipeBackWhenNavigationBarHidden
{
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
//    {
//        self.systemSwipeBackDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
//        self.systemSwipeBackEnable = self.navigationController.interactivePopGestureRecognizer.enabled;
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//        self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    }
}

#pragma mark- 百度统计进入页面，建议在此处添加
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ( ISNSStringValid(self.title)  )
    {
        NSString* cName = [NSString stringWithFormat:@"%@",  self.title, nil];
        [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    }
    else if ( ISNSStringValid(self.navigationItem.title) )
    {
        NSString* cName = [NSString stringWithFormat:@"%@", self.navigationItem.title, nil];
        [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    }
    
}

#pragma mark- 百度统计退出页面，建议在此处添加
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if ( ISNSStringValid(self.title) )
    {
        NSString* cName = [NSString stringWithFormat:@"%@", self.title, nil];
        [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
    }
    else if ( ISNSStringValid(self.navigationItem.title) )
    {
        NSString* cName = [NSString stringWithFormat:@"%@", self.navigationItem.title, nil];
        [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
    }
}


@end
