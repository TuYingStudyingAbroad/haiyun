//
//  MKMarketingSingleLineView.m
//  YangDongXi
//
//  Created by cocoa on 15/5/5.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKMarketingSingleLineView.h"
#import "MKTopBottomButton.h"
#import <PureLayout.h>
#import <UIButton+WebCache.h>
#import "UIColor+MKExtension.h"


@interface MKMarketingSingleLineView ()

@property (nonatomic, strong) NSArray *views;

@end


@implementation MKMarketingSingleLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self marketingViewInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self marketingViewInit];
}

- (void)marketingViewInit
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)updateViews:(NSArray *)views
{
    [self updateViews:views withSeperator:NO];
}

- (void)updateViews:(NSArray *)views withSeperator:(BOOL)sp
{
    NSInteger rowCount = ceilf(1.0 * views.count/KNumberOfIconsInLine);
    
    for (int row = 0; row < rowCount; row ++)
    {
        NSInteger currentColumnCount = KNumberOfIconsInLine;
        
        if(views.count/((row + 1) * KNumberOfIconsInLine) == 0)
        {
            currentColumnCount = views.count % KNumberOfIconsInLine;
        }
        for (int column = 0; column < currentColumnCount ; column ++)
        {
            UIView *currentView = [views objectAtIndex:(column + row * KNumberOfIconsInLine)];
            
            [self addSubview:currentView];
            
            currentView.translatesAutoresizingMaskIntoConstraints = NO;
            
            NSLayoutConstraint *constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:((2.0 * column + 1)/currentColumnCount)constant:0.0];
            [self addConstraint:constaint];
            
            constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:(1.0/currentColumnCount) constant:0.0];
            
            [self addConstraint:constaint];
            
            constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:(1.0/rowCount) constant:0.0];
            
            [self addConstraint:constaint];
            
            constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:((2.0 * row + 1)/rowCount) constant:0.0];
            
            [self addConstraint:constaint];
            
            if (sp && column > 0)
            {
                UIView *sp = [[UIView alloc] init];
                
                sp.backgroundColor = [UIColor colorWithHex:0xe5e5e5];
                
                [self addSubview:sp];
                
                [sp autoPinEdgeToSuperviewEdge:ALEdgeBottom];
                
                [sp autoPinEdgeToSuperviewEdge:ALEdgeTop];
                
                [sp autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:views[column - 1]];
                
                [sp autoSetDimension:ALDimensionWidth toSize:0.5];
            }
        }
    }
    
    self.views = views;
}

- (void)updatHorizationaleViews:(NSArray *)views withSeperator:(BOOL)sp isLeft:(BOOL)isLeft
{
    if(views.count < 3)
    {
        [self updateViews:views withSeperator:sp];
        
        return;
    }
    
    for(int index = 0; index < 3; index ++)
    {
        UIView *currentView = [views objectAtIndex:index];
        
        [self addSubview:currentView];
        
        currentView.translatesAutoresizingMaskIntoConstraints = NO;
        
        if(index == 0)
        {
            NSLayoutConstraint *constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
            
            [self addConstraint:constaint];
            
            constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
            
            [self addConstraint:constaint];
            
            constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0.0];
            
            [self addConstraint:constaint];
            
            if(isLeft)
            {
                constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0.0];
                
            }
            else
            {
                constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
                
            }
            
            [self addConstraint:constaint];
            
        }
        else if(index == 1)
        {
            if(isLeft)
            {
                NSLayoutConstraint *constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
                
                [self addConstraint:constaint];
                
                constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
                
                [self addConstraint:constaint];
                
                constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0.0];
                
                [self addConstraint:constaint];
                
                constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0.0];
                
                [self addConstraint:constaint];
                
                if (sp)
                {
                    UIView *sp = [[UIView alloc] init];
                    
                    sp.backgroundColor = [UIColor colorWithHex:0xe5e5e5];
                    
                    [self addSubview:sp];
                    
                    [sp autoPinEdgeToSuperviewEdge:ALEdgeLeft];
                    
                    [sp autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:currentView];
                    
                    [sp autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:currentView];
                    
                    [sp autoSetDimension:ALDimensionHeight toSize:0.5];
                }
                
            }
            else
            {
                NSLayoutConstraint *constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
                
                [self addConstraint:constaint];
                
                constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
                
                [self addConstraint:constaint];
                
                constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0.0];
                
                [self addConstraint:constaint];
                
                constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0.0];
                
                [self addConstraint:constaint];
                
                if (sp)
                {
                    UIView *sp = [[UIView alloc] init];
                    
                    sp.backgroundColor = [UIColor colorWithHex:0xe5e5e5];
                    
                    [self addSubview:sp];
                    
                    [sp autoPinEdgeToSuperviewEdge:ALEdgeBottom];
                    
                    [sp autoPinEdgeToSuperviewEdge:ALEdgeTop];
                    
                    [sp autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:currentView];
                    
                    [sp autoSetDimension:ALDimensionWidth toSize:0.5];                }
                
            }
        }
        else
        {
            if(isLeft)
            {
                NSLayoutConstraint *constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
                
                [self addConstraint:constaint];
                
                constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
                
                [self addConstraint:constaint];
                
                constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0.0];
                
                [self addConstraint:constaint];
                
                constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0];
                
                [self addConstraint:constaint];
                
                if (sp)
                {
                    UIView *sp = [[UIView alloc] init];
                    
                    sp.backgroundColor = [UIColor colorWithHex:0xe5e5e5];
                    
                    [self addSubview:sp];
                    
                    [self bringSubviewToFront:sp];
                    
                    [sp autoPinEdgeToSuperviewEdge:ALEdgeBottom];
                    
                    [sp autoPinEdgeToSuperviewEdge:ALEdgeTop];
                    
                    [sp autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:currentView];
                    
                    [sp autoSetDimension:ALDimensionWidth toSize:0.5];
                }
            }
            else
            {
                NSLayoutConstraint *constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
                
                [self addConstraint:constaint];
                
                constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
                
                [self addConstraint:constaint];
                
                constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0.0];
                
                [self addConstraint:constaint];
                
                constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0.0];
                
                [self addConstraint:constaint];
                
                if (sp)
                {
                    UIView *sp = [[UIView alloc] init];
                    
                    sp.backgroundColor = [UIColor colorWithHex:0xe5e5e5];
                    
                    [self addSubview:sp];
                    
                    [self bringSubviewToFront:sp];
                    
                    [sp autoPinEdgeToSuperviewEdge:ALEdgeRight];
                    
                    [sp autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:currentView];
                    
                    [sp autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:currentView];
                    
                    [sp autoSetDimension:ALDimensionHeight toSize:0.5];
                }
                
            }
        }
    }
    
    self.views = views;
}

- (void)updateVerticalViews:(NSArray *)views withSeperator:(BOOL)sp isLeft:(BOOL)isLeft
{
    if(views.count < 3)
    {
        [self updateViews:views withSeperator:sp];
    }
    for (int index = 0; index < 3; index ++)
    {
        UIView *currentView = [views objectAtIndex:index];
        [self addSubview:currentView];
        
        currentView.translatesAutoresizingMaskIntoConstraints = NO;
        
        if (index == 0)
        {
            NSLayoutConstraint *constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
            
            [self addConstraint:constaint];
            
            constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
            
            [self addConstraint:constaint];
            
            constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
            
            [self addConstraint:constaint];
            
            if(isLeft)
            {
                constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0/4.0 constant:0.0];
            }
            else
            {
                constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0/2.0 constant:0.0];
            }
            
            [self addConstraint:constaint];
            
        }
        else if (index == 1)
        {
            NSLayoutConstraint *constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0/4.0 constant:0.0];
            
            [self addConstraint:constaint];
            
            constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
            
            [self addConstraint:constaint];
            
            constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
            
            [self addConstraint:constaint];
            
            if(isLeft)
            {
                constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:[UIScreen mainScreen].bounds.size.width/4.0];
            }
            else
            {
                constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:[UIScreen mainScreen].bounds.size.width/2.0];
            }
            
            [self addConstraint:constaint];
            
            if(sp)
            {
                UIView *sp = [[UIView alloc] init];
                
                sp.backgroundColor = [UIColor colorWithHex:0xe5e5e5];
                
                [self addSubview:sp];
                
                [sp autoPinEdgeToSuperviewEdge:ALEdgeBottom];
                
                [sp autoPinEdgeToSuperviewEdge:ALEdgeTop];
                
                [sp autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:currentView];
                
                [sp autoSetDimension:ALDimensionWidth toSize:0.5];
            }
            
        }
        else
        {
            NSLayoutConstraint *constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
            
            [self addConstraint:constaint];
            
            constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
            
            [self addConstraint:constaint];
            
            constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
            
            [self addConstraint:constaint];
            
            if(isLeft)
            {
                constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0/2.0 constant:0.0];
            }
            else
            {
                constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0/4.0 constant:0.0];
            }
            
            [self addConstraint:constaint];
            
            if(sp)
            {
                UIView *sp = [[UIView alloc] init];
                
                sp.backgroundColor = [UIColor colorWithHex:0xe5e5e5];                [self addSubview:sp];
                
                [sp autoPinEdgeToSuperviewEdge:ALEdgeBottom];
                
                [sp autoPinEdgeToSuperviewEdge:ALEdgeTop];
                
                [sp autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:currentView];
                
                [sp autoSetDimension:ALDimensionWidth toSize:0.5];
            }
        }
    }
}

-(void)updateStyle4Views:(NSArray *)views withSeperator:(BOOL)sp
{
    if(views.count < 4)
    {
        [self updateViews:views withSeperator:sp];
    }
    for (int index = 0; index < 4; index ++)
    {
        UIView *currentView = [views objectAtIndex:index];
        
        [self addSubview:currentView];
        
        currentView.translatesAutoresizingMaskIntoConstraints = NO;
        
        if (index == 0)
        {
            NSLayoutConstraint *constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
            
            [self addConstraint:constaint];
            
            constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
            
            [self addConstraint:constaint];
            
            constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
            
            [self addConstraint:constaint];
            
            constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0/2.0 constant:0.0];
            
            [self addConstraint:constaint];
            
        }
        else if (index == 1)
        {
            NSLayoutConstraint *constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
            
            [self addConstraint:constaint];
            
            constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
            
            [self addConstraint:constaint];
            
            constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0/2.0 constant:0.0];
            
            [self addConstraint:constaint];
            
            constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0/2.0 constant:0.0];
            
            [self addConstraint:constaint];
            
            if(sp)
            {
                UIView *sp = [[UIView alloc] init];
                
                sp.backgroundColor = [UIColor colorWithHex:0xe5e5e5];
                
                [self addSubview:sp];
                
                [sp autoPinEdgeToSuperviewEdge:ALEdgeBottom];
                
                [sp autoPinEdgeToSuperviewEdge:ALEdgeTop];
                
                [sp autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:currentView];
                
                [sp autoSetDimension:ALDimensionWidth toSize:0.5];
            }
            
        }
        else if (index == 2)
        {
            NSLayoutConstraint *constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
            
            [self addConstraint:constaint];
            
            constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:[UIScreen mainScreen].bounds.size.width/2.0 + 0.5];
            
            [self addConstraint:constaint];
            
            constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0/4.0 constant:0.0];
            
            [self addConstraint:constaint];
            
            constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0/2.0 constant:0.0];
            
            [self addConstraint:constaint];
            
            if(sp)
            {
                UIView *sp = [[UIView alloc] init];
                
                sp.backgroundColor = [UIColor colorWithHex:0xe5e5e5];
                
                [self addSubview:sp];
                
                [sp autoPinEdgeToSuperviewEdge:ALEdgeRight];
                
                [sp autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:currentView];
                
                [sp autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:currentView];
                
                [sp autoSetDimension:ALDimensionHeight toSize:0.5];
            }
        }
        
        
        else
        {
            NSLayoutConstraint *constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
            
            [self addConstraint:constaint];
            
            constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
            
            [self addConstraint:constaint];
            
            constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0/4.0 constant:0.0];
            
            [self addConstraint:constaint];
            
            constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0/2.0 constant:-0.5];
            
            [self addConstraint:constaint];
            
            if(sp)
            {
                UIView *sp = [[UIView alloc] init];
                
                sp.backgroundColor = [UIColor colorWithHex:0xe5e5e5];
                [self addSubview:sp];
                [sp autoPinEdgeToSuperviewEdge:ALEdgeBottom];
                
                [sp autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:currentView];
                
                [sp autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:currentView];
                
                [sp autoSetDimension:ALDimensionWidth toSize:0.5];
            }
        }
    }
}

-(void)updateStyle3Views:(NSArray *)views withSeperator:(BOOL)sp isLeft:(BOOL)isLeft
{
    if(views.count < 2)
    {
        [self updateViews:views withSeperator:sp];
    }
    for (int index = 0; index < 2; index ++)
    {
        UIView *currentView = [views objectAtIndex:index];
        
        [self addSubview:currentView];
        
        currentView.translatesAutoresizingMaskIntoConstraints = NO;
        
        if (index == 0)
        {
            NSLayoutConstraint *constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
            
            [self addConstraint:constaint];
            
            constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
            
            [self addConstraint:constaint];
            
            constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
            
            [self addConstraint:constaint];
            
            if(isLeft)
            {
                constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0/3.0 constant:0.0];
            }
            else
            {
                constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:2.0/3.0 constant:0.0];
            }
            
            [self addConstraint:constaint];
            
        }
        else
        {
            NSLayoutConstraint *constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
            
            [self addConstraint:constaint];
            
            constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
            
            [self addConstraint:constaint];
            
            constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
            
            [self addConstraint:constaint];
            
            if(isLeft)
            {
                constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:2.0/3.0 constant:0.0];
            }
            else
            {
                constaint = [NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0/3.0 constant:0.0];
            }
            
            [self addConstraint:constaint];
            
            if(sp)
            {
                UIView *sp = [[UIView alloc] init];
                
                sp.backgroundColor = [UIColor colorWithHex:0xe5e5e5];
                
                [self addSubview:sp];
                
                [sp autoPinEdgeToSuperviewEdge:ALEdgeBottom];
                
                [sp autoPinEdgeToSuperviewEdge:ALEdgeTop];
                
                [sp autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:currentView];
                
                [sp autoSetDimension:ALDimensionWidth toSize:0.5];
            }
            
        }
    }
    
}

/*
 - (void)updateViews:(NSArray *)views withSeperator:(BOOL)sp
 {
 NSMutableDictionary *lvs = [NSMutableDictionary dictionary];
 
 NSMutableString *vlf = [NSMutableString stringWithString:@"H:|"];
 
 for (int i = 0; i < views.count; ++i)
 {
 UIView *v = views[i];
 
 [v setTranslatesAutoresizingMaskIntoConstraints:NO];
 
 NSString *vk = [NSString stringWithFormat:@"v%i", i];
 
 lvs[vk] = v;
 
 NSString *mvls = @"";
 
 if (i > 0)
 {
 mvls = [NSString stringWithFormat:@"(==v%i)", i - 1];
 
 if (sp)
 {
 UIView *sp = [[UIView alloc] init];
 sp.backgroundColor = [UIColor colorWithHex:0xe5e5e5];
 [self addSubview:sp];
 [sp autoPinEdgeToSuperviewEdge:ALEdgeBottom];
 [sp autoPinEdgeToSuperviewEdge:ALEdgeTop];
 [sp autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:views[i - 1]];
 [sp autoSetDimension:ALDimensionWidth toSize:0.5];
 }
 }
 
 [vlf appendFormat:@"[%@%@]", vk, mvls];
 
 [self addSubview:v];
 
 NSArray *a = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v]|" options:0
 metrics:nil views:@{@"v" : v}];
 [self addConstraints:a];
 
 }
 
 [vlf appendString:@"|"];
 
 self.views = views;
 
 NSArray *a = [NSLayoutConstraint constraintsWithVisualFormat:vlf options:NSLayoutFormatAlignAllCenterY metrics:nil views:lvs];
 
 [self addConstraints:a];
 }
 
 */

@end
