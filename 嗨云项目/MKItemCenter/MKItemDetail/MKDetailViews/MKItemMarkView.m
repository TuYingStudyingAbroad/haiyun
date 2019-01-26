//
//  MKItemMarkView.m
//  嗨云项目
//
//  Created by 李景 on 16/5/17.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKItemMarkView.h"
#import "MKSKUPropertyObject.h"
#import <PureLayout.h>
#import "MKMarkView.h"
#import "UIView+MKExtension.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

#define horizontalMargin 5
#define verticalMargin 15
#define buttonHeight 26

@interface MKItemMarkView (){
    BOOL isNewline;
    BOOL canNewline;
}

@property (nonatomic, assign) NSInteger abc;
@property (nonatomic, strong) UIButton *arrowButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation MKItemMarkView



- (void)buildItemMarkViewWithArray:(NSArray *) array {
    CGFloat width = 0;
    UIView *mainScrollView = [[UIView alloc] init];
    UIView *layoutLeftView = nil;
    CGFloat abc = 56;
    _scrollView.contentSize = CGSizeMake(array.count * 100 + ([UIScreen mainScreen].bounds.size.width - 3* 100 ) / 4 * (array.count + 1), 0);
    [self addSubview:_scrollView];
    [_scrollView addSubview:mainScrollView];
    for (NSDictionary * dic in array) {
        MKMarkView *markView = [MKMarkView loadFromXib];
        markView.nameLabel.text = dic[@"label_name"];
        [markView.nameIocn sd_setImageWithURL:[NSURL URLWithString:dic[@"icon_url"]] placeholderImage:[UIImage imageNamed:@"placeholder_80x80"]];
        [mainScrollView addSubview:markView];
        [markView sizeToFit];
        [self layoutIfNeeded];
        
        [markView autoSetDimension:ALDimensionHeight toSize:26];
        if (layoutLeftView == nil) {
            [markView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:([UIScreen mainScreen].bounds.size.width - 3* 100 ) / 4];
        }else {
            [markView autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:layoutLeftView withOffset:([UIScreen mainScreen].bounds.size.width - 3* 100 ) / 4];
            width = width + layoutLeftView.bounds.size.width;
        }
        [markView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:12];
        
        layoutLeftView = markView;
        [layoutLeftView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:20];
        self.abc = abc;
    }
    
    [self autoSetDimension:ALDimensionHeight toSize:self.abc];
}

//- (void)touchRised {
//    
//    [_arrowButton autoPinEdgeToSuperviewEdge:(ALEdgeRight) withInset:12];
//    [_arrowButton autoPinEdgeToSuperviewEdge:(ALEdgeTop) withInset:22];
//    [_arrowButton autoSetDimension:(ALDimensionHeight) toSize:20];

//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
