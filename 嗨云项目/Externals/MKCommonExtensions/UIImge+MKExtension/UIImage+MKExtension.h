//
//  UIImage+MKExtension.h
//  YangDongXi
//
//  Created by 杨鑫 on 15/9/18.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MKExtension)
- (UIImage *)imageWithColor:(UIColor *)color;
- (UIImage *) imageWithTintColor:(UIColor *)tintColor;
- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;
@end
