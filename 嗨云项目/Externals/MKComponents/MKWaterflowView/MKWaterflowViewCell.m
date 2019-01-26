//
//  MKWaterflowViewCell.m
//  MKBaseLibDemo
//
//  Created by windy on 15/4/3.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKWaterflowViewCell.h"

@interface MKWaterflowViewCell ()

@property (nonatomic, strong) MKWaterflowViewLayoutAttributes *layoutAttributes;

@end

@implementation MKWaterflowViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)applyLayoutAttributes:(MKWaterflowViewLayoutAttributes *)layoutAttributes{
    if (_layoutAttributes != layoutAttributes) {
        _layoutAttributes = layoutAttributes;
        
        self.frame = layoutAttributes.frame;
        self.center = layoutAttributes.center;
        self.hidden = layoutAttributes.isHidden;
    }
}

- (void)prepareForReuse{
    self.layoutAttributes = nil;
}
@end
