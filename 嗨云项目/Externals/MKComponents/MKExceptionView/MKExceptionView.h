//
//  MKExceptionView.h
//  YangDongXi
//
//  Created by cocoa on 15/5/25.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+MKExtension.h"

@interface MKExceptionView : UIView
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) IBOutlet UILabel *exceptionLabel;
@property (weak, nonatomic) IBOutlet UIView *circleView;
@property (weak, nonatomic) IBOutlet UIButton *goHomePageBtn;

@end
