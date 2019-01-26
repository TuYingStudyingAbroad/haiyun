//
//  firstSeckillingCell.m
//  嗨云项目
//
//  Created by 小辉 on 16/10/12.
//  Copyright © 2016年 haiyun. All rights reserved.
//

#import "firstSeckillingCell.h"
#import "firstSeckillingCutDownView.h"
#import "UIView+MKExtension.h"
#import <UIImageView+WebCache.h>
#import "seckillingBtnView.h"

@interface firstSeckillingCell()<firstSeckillingCutDownViewDelegate>

@property (nonatomic,strong)firstSeckillingCutDownView * firstSCD;

@end

@implementation firstSeckillingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self setView];
    }
    return self;
   
}

-(firstSeckillingCutDownView *)firstSCD{
    if (!_firstSCD) {
        
        _firstSCD=[firstSeckillingCutDownView loadFromXib];
        _firstSCD.delegate=self;
       
    }
    return _firstSCD;
}

-(void)setView{

    [self.contentView addSubview:self.firstSCD];
    self.firstSCD.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint * constaint=[NSLayoutConstraint constraintWithItem:self.firstSCD attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0  constant:0];
    [self.contentView addConstraint:constaint];
    
    constaint = [NSLayoutConstraint constraintWithItem:self.firstSCD attribute:NSLayoutAttributeCenterY
                                                relatedBy:NSLayoutRelationEqual
                                                   toItem:self.contentView  attribute:NSLayoutAttributeCenterY
                                               multiplier:1.0f constant:-0.0f];
    [self.contentView addConstraint:constaint];
    
    constaint=[NSLayoutConstraint constraintWithItem:self.firstSCD attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0  constant:0];
    [self.contentView addConstraint:constaint];
    constaint = [NSLayoutConstraint constraintWithItem:self.firstSCD attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self.contentView addConstraint:constaint];
    
    constaint = [NSLayoutConstraint constraintWithItem:self.firstSCD attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self.contentView addConstraint:constaint];
}

-(void)updateWithEntryObject:(MKMarketingComponentObject *)object{
    [super updateWithEntryObject:object];
    
    
    NSArray *array = [[NSArray alloc] init];
    array=object.values;
    [_firstSCD setUpATopScrollMenu:array];
    
   
  
}
- (void)firstSeckillingCutDownViewImgVClick:(NSInteger) tag{
    if ( tag>=0 && tag < self.entryObject.values.count ) {
        MKMarketingObject *ob = self.entryObject.values[tag];
        if ( self.delegate && [self.delegate respondsToSelector:@selector(marketingCell:didClickWithUrl:)]) {
            [self.delegate marketingCell:self didClickWithUrl:ob.targetUrl];
        }
    }

}



+(CGFloat)cellHeight{
    return 300;
}

@end
