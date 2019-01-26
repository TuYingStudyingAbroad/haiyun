//
//  MKExceptionView.m
//  YangDongXi
//
//  Created by cocoa on 15/5/25.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKExceptionView.h"
#import "AppDelegate.h"
#import "UIColor+MKExtension.h"

@interface MKExceptionView ()

@property (nonatomic, strong) IBOutlet UIView *circleView;

@end


@implementation MKExceptionView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.circleView.layer.cornerRadius = self.circleView.frame.size.width / 2;
}

@end
