//
//  MKDetailBaseInfoView.m
//  YangDongXi
//
//  Created by cocoa on 15/4/27.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKDetailBaseInfoView.h"
#import <PureLayout.h>


@interface MKDetailBaseInfoView ()
{
    NSInteger TitleOffset;
}

@property (nonatomic, weak) IBOutlet UILabel *originTitleLabel;

@property (nonatomic, weak) IBOutlet UILabel *originSignLabel;
@property (weak, nonatomic) IBOutlet UILabel *originPriceMark;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *originPricePinTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *privceLeading;

@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;

@end

@implementation MKDetailBaseInfoView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    TitleOffset = 0;
    
//    [self updateHeight:100];
    
    //self.discountBackgroundView.layer.cornerRadius = 2;
}

- (void)hideOriginPrice:(BOOL)hide
{
    self.originTitleLabel.hidden = hide;
    self.originSignLabel.hidden = hide;
    self.originPriceLabel.hidden = hide;
    self.originPriceMark.hidden = hide;
//    self.discountLabel.hidden = hide;
//    self.discountBackgroundView.hidden = hide;
    
//    if([self isMoreThanOneLineWithHeightForWidth:([UIScreen mainScreen].bounds.size.width - 24) usingFont:[UIFont systemFontOfSize:16.0] string:self.titleLabel.text])
//    {
//        TitleOffset = 0;
//    }
//    else
//    {
//        
//        TitleOffset = 16;
//    }
    
//    if (hide)
//    {
//        
//        for(NSLayoutConstraint *sConstraint in self.constraints)
//        {
//            if(sConstraint.firstItem == self.freePostageView && sConstraint.firstAttribute == NSLayoutAttributeLeading)
//            {
//                sConstraint.constant = 20;
//            }
//
//        }
    
//        [self updateHeight:(84 - TitleOffset)];

//    }
//    
//    else if (self.originPricePinTop == nil)
//    {
//        for(NSLayoutConstraint *sConstraint in self.constraints)
//        {
//            if(sConstraint.firstItem == self.freePostageView && sConstraint.firstAttribute == NSLayoutAttributeLeading)
//            {
//                sConstraint.constant = 56;
//            }
//            
//        }
    
//        [self updateHeight:(100 - TitleOffset)];
//    }
}

- (void)updateHeight:(CGFloat)height
{
//    if (self.heightConstraint == nil)
//    {
//        self.heightConstraint = [self autoSetDimension:ALDimensionHeight toSize:height];
//    }
//    else
//    {
//        self.heightConstraint.constant = height;
//    }
}

-(void)hideLimitedView:(NSInteger)itemType skuNum:(BOOL)cannotBuy
{
    if (itemType == 21 )
    {
        self.limitedView.hidden = NO;
        self.privceLeading.constant = 52.0f;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 58.0f, 16.0f)
                                                       byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight
                                                             cornerRadii:CGSizeMake(8, 8)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0, 58.0f, 16.0f);
        maskLayer.path = maskPath.CGPath;
        self.limitedView.layer.mask = maskLayer;
        if ( cannotBuy )
        {
            self.limitedView.backgroundColor = kHEXCOLOR(0xff3333);
        }else
        {
            self.limitedView.backgroundColor = kHEXCOLOR(0xb3b3b3);
        }
    }else
    {
        self.limitedView.hidden = YES;
        self.privceLeading.constant = 0.0f;
    }
}
- (BOOL)isMoreThanOneLineWithHeightForWidth:(CGFloat)width usingFont:(UIFont *)font string:(NSString *)string
{
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize labelSize = (CGSize){width, FLT_MAX};
    CGRect r = [string boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:context];
    if(r.size.height > 20)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
