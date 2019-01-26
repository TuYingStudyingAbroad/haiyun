//
//  MKStrikethroughLabel.m
//  YangDongXi
//
//  Created by cocoa on 15/4/29.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKStrikethroughLabel.h"

@implementation MKStrikethroughLabel

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"text"];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initStrikethrough];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initStrikethrough];
}

- (void)initStrikethrough
{
    [self strikethroughText];
    [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self strikethroughText];
}

- (void)strikethroughText
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attributeString addAttribute:NSStrikethroughStyleAttributeName
                            value:@1
                            range:NSMakeRange(0, [attributeString length])];
    self.attributedText = attributeString;
}

@end
