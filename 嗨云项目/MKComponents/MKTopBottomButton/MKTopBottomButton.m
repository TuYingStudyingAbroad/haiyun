//
//  MKTopBottomButton.m
//  YangDongXi
//
//  Created by cocoa on 15/5/5.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKTopBottomButton.h"

@implementation MKTopBottomButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    // the space between the image and text
    
    // lower the text and push it left so it appears centered
    //  below the image
    CGSize imageSize = self.imageView.image.size;
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width,
                                            - (imageSize.height + self.spacingBetweenImageAndText), 0.0);
    
    // raise the image and push it right so it appears centered
    //  above the text
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    self.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + self.spacingBetweenImageAndText),
                                            0.0, 0.0, - titleSize.width);
}

@end
