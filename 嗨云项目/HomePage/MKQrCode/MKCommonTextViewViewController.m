//
//  MKCommonTextViewViewController.m
//  YangDongXi
//
//  Created by windy on 15/4/22.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKCommonTextViewViewController.h"



@interface MKCommonTextViewViewController ()

@property (nonatomic, strong) IBOutlet UITextView *textView;

@end

@implementation MKCommonTextViewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"扫到的文本";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.textView.text = self.text;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

@end
