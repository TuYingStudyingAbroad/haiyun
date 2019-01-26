//
//  MKMarketingDividerLineCell.m
//  YangDongXi
//
//  Created by Constance Yang on 24/07/2015.
//  Copyright (c) 2015 yangdongxi. All rights reserved.
//

#import "MKMarketingDividerLineCell.h"
#import "UIColor+MKExtension.h"

@interface MKMarketingDividerLineCell()

@property (strong,nonatomic) CAShapeLayer *seperatorLineLayer;

@end

@implementation MKMarketingDividerLineCell

- (void)updateWithEntryObject:(MKMarketingComponentObject *)object
{
    [super updateWithEntryObject:object];
    
    //[self setBottomSeperatorLineMarginLeft:0 rigth:0];
    self.bottomSeperatorLine.hidden = YES;
    
    [self resetInforamtion];
}

+(CGFloat)cellHeight
{
    return kDefaultDividerMargin + kDefaultDividerMargin + kDefaultDividerLineHeight;
}

#pragma mark --
#pragma mark -- configuration method

-(void)resetInforamtion
{
    MKMarketingObject *lineInformation = [self.entryObject.values objectAtIndex:0];
    
    NSString *bgColorInHex = lineInformation.bgColor;
    
    if(bgColorInHex && [bgColorInHex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0)
    {
        self.contentView.backgroundColor = [UIColor colorWithHexString:[bgColorInHex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
    else
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    CGFloat topPadding = (lineInformation.topPadding) ? [lineInformation.topPadding floatValue]/2.0 : kDefaultDividerMargin;
    
    CGFloat leftPadding = (lineInformation.leftPadding) ? [lineInformation.leftPadding floatValue]/2.0 : 0.0 ;
    
    CGFloat rightPadding = (lineInformation.rightPadding) ? [lineInformation.rightPadding floatValue]/2.0 : 0.0 ;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint startPoint = CGPointMake(leftPadding, topPadding);
    
    CGPoint endPoint = CGPointMake([UIScreen mainScreen].bounds.size.width - rightPadding, topPadding);
    
    [path moveToPoint:startPoint];
    
    [path addLineToPoint:endPoint];
    
    if(self.seperatorLineLayer != nil)
    {
        [self.seperatorLineLayer removeFromSuperlayer];
        
        self.seperatorLineLayer = nil;
    }
    self.seperatorLineLayer = [CAShapeLayer layer];
    
    self.seperatorLineLayer.path = path.CGPath;
    
    self.seperatorLineLayer.strokeColor = [UIColor colorWithHexString:@"#e5e5e5"].CGColor;
    
    if([lineInformation.type isEqualToString:@"dashed"])
    {
        self.seperatorLineLayer.lineDashPattern = @[@3, @3];
        
        //self.seperatorLineLayer.fillColor = [UIColor redColor].CGColor;
    }
    self.seperatorLineLayer.lineWidth = kDefaultDividerLineHeight;

    self.seperatorLineLayer.strokeStart = 0.0;
    
    self.seperatorLineLayer.strokeEnd = 1.0;
    
    [self.contentView.layer addSublayer:self.seperatorLineLayer];
}

@end
