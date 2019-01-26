//
//  MKDeliveryDetailCell.m
//  YangDongXi
//
//  Created by windy on 15/5/5.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKDeliveryDetailCell.h"
#import "UIColor+MKExtension.h"
#import <PureLayout.h>

@interface MKDeliveryDetailCell()

@property (nonatomic, strong) IBOutlet UIView *borderCircle;

@property (nonatomic, strong) IBOutlet UIView *roundPoint;

@property (nonatomic, strong) IBOutlet UIView *grayDot;

@property (nonatomic, strong) IBOutlet UIView *verticalLine;

@property (nonatomic, strong) IBOutlet UIView *bottomLine;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *verticalLinePinTopConstraint;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *verticalLinePinBottomConstraint;

@property (nonatomic, strong) IBOutlet UILabel *contentLabel;

@end

@implementation MKDeliveryDetailCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.borderCircle.layer.cornerRadius = self.borderCircle.frame.size.height / 2;
    self.roundPoint.layer.cornerRadius = self.roundPoint.frame.size.width / 2;
    self.grayDot.layer.cornerRadius = self.grayDot.frame.size.width / 2;
}

- (void)updateExpressInfo:(NSString *)expressInfo andTime:(NSString *)timeString
{
    expressInfo = [expressInfo stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    timeString = [timeString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *content = [NSString stringWithFormat:@"%@\n%@", expressInfo, timeString];
    self.contentLabel.attributedText = [MKDeliveryDetailCell attributeForString:content];
}

- (void)updateCellPosition:(DeliveryCellPosition)position
{
    [self.contentView removeConstraints:@[self.verticalLinePinTopConstraint, self.verticalLinePinBottomConstraint]];
    
    BOOL highlight = position == DeliveryCellPositionTop || position == DeliveryCellPositionSingle;
    
    self.borderCircle.hidden = !highlight;
    self.roundPoint.hidden = !highlight;
    self.grayDot.hidden = highlight;
    
    self.contentLabel.textColor = highlight ? [UIColor colorWithHex:0x7fca15] : [UIColor colorWithHex:0x666666];
    
    if (position == DeliveryCellPositionTop || position == DeliveryCellPositionSingle)
    {
        self.verticalLinePinTopConstraint = [self.verticalLine autoPinEdge:ALEdgeTop toEdge:ALEdgeTop
                                                                    ofView:self.roundPoint withOffset:2];
    }
    else
    {
        self.verticalLinePinTopConstraint = [self.verticalLine autoPinEdgeToSuperviewEdge:ALEdgeTop];
    }
    
    if ( position == DeliveryCellPositionSingle)//position == DeliveryCellPositionBottom ||
    {
        self.verticalLinePinBottomConstraint = [self.verticalLine autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom
                                                                       ofView:self.roundPoint withOffset:-2];
        self.bottomLine.hidden = YES;

    }
    else
    {
        self.verticalLinePinBottomConstraint = [self.verticalLine autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    }
}

+ (CGFloat)calculateHeightWithContent:(NSString *)content withWidth:(CGFloat)width
{
    content = [content stringByAppendingString:@"\ntime"];
    
    CGRect rect = [[self attributeForString:content] boundingRectWithSize:CGSizeMake(width - 71, CGFLOAT_MAX)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return ceilf(rect.size.height) + 30;
}

+ (NSAttributedString *)attributeForString:(NSString *)string
{
    NSMutableAttributedString *attributedStr =
    [[NSMutableAttributedString alloc] initWithString:string
                                           attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, [string length])];
    return attributedStr;
}

@end
