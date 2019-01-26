//
//  HYSearchsNewView.m
//  嗨云项目
//
//  Created by haiyun on 16/9/20.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#define horizontalMargin 5
#define verticalMargin 6
#define buttonHeight 42


#import "HYSearchsNewView.h"
#import "HYOnewordView.h"
#import <PureLayout.h>

@interface HYSearchsNewView ()<HYOnewordViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet UIImageView *titlImageView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (assign, nonatomic) NSInteger delTags;

@property (assign, nonatomic) BOOL isTag;

@end

@implementation HYSearchsNewView

- (void)awakeFromNib
{
    [super awakeFromNib];
}
- (void)buildSearchsNewView:(NSArray *)props title:(NSString *)titles isRight:(BOOL)isHide
{
    self.delTags = -1;
    self.isTag = isHide;
    if ( isHide ) {
        self.delBtn.hidden = YES;
        self.titlImageView.image = [UIImage imageNamed:@"HYremensousuo"];
    }else
    {
        self.delBtn.hidden = NO;
        self.titlImageView.image = [UIImage imageNamed:@"HYlishisousuo"];
    }
    self.titleLabel.text = titles;
    
    UIView *layoutTopView = self.lineView;
    UIView *layoutLeftView = nil;
    
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:props.count];
    int index = 0;
    CGFloat abc = 60;
    CGFloat startX = 12.0f;
    for (NSString *attr in props)
    {
        HYOnewordView *oneView = [HYOnewordView loadFromXib];
        oneView.wordLabel.text = attr;
        oneView.delBtn.hidden = YES;
        oneView.isTag = !isHide;
        oneView.delegate = self;
        [self addSubview:oneView];
        
        CGFloat titleWidth = GetWidthOfString(attr, 20.0f, [UIFont systemFontOfSize:12.0f])+38.0f;
       

        if ( titleWidth>= Main_Screen_Width-2*12.0f ) {
            titleWidth = Main_Screen_Width-2*12.0f;
        }
        oneView.tag = index ++ ;
        [buttons addObject:oneView];
        [oneView autoSetDimension:ALDimensionWidth toSize:titleWidth];
        [oneView autoSetDimension:ALDimensionHeight toSize:buttonHeight];

        if (layoutLeftView != nil && startX + titleWidth  + 12.0f >= Main_Screen_Width)
        {
            layoutTopView = layoutLeftView;
            layoutLeftView = nil;
            startX = 12.0f;

        }
        
        if (layoutLeftView == nil)
        {
            abc += 8+verticalMargin;
            [oneView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:12.0];
        }
        else
        {
            [oneView autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:layoutLeftView withOffset:0];
        }
        
        [oneView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:layoutTopView withOffset:verticalMargin];
        if ([attr isEqualToString:@""]) {
            [oneView autoSetDimension:(ALDimensionWidth) toSize:0];
            [oneView autoSetDimension:(ALDimensionHeight) toSize:0];
        }
        layoutLeftView = oneView;
        startX += titleWidth;

    }
    self.abc = abc;
    self.propertyButtons = [buttons copy];
    [layoutLeftView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:8];
}

- (IBAction)onButton:(id)sender {
    
    if ( sender == self.delBtn )
    {
        [self searchClick:1 tag:0];
    }
}

///1删除，2点击搜索，3显示删除按钮
- (void)onewordView:(HYOnewordView *)wordView changeIndex:(NSInteger)index
{
    if ( index == 1 )
    {
        [self searchClick:2 tag:wordView.tag];
    }
    else if ( index == 2 )
    {
        NSInteger ondex = 3;
        if ( self.isTag ) {
            ondex = 4;
        }
        [self searchClick:ondex tag:wordView.tag];

    }
    else if( index == 3  )
    {
        if ( self.delTags>=0 && self.delTags < self.propertyButtons.count ) {
            HYOnewordView *oneVc = self.propertyButtons[self.delTags];
            oneVc.delBtn.hidden = YES;
        }
        self.delTags = wordView.tag;
    }
}

-(void)searchClick:(NSInteger)index tag:(NSInteger)tags
{
    if ( _delegate && [_delegate respondsToSelector:@selector(searchsNewView:changeIndex:tags:)]) {
        [_delegate searchsNewView:self changeIndex:index tags:tags];
    }
}
@end
