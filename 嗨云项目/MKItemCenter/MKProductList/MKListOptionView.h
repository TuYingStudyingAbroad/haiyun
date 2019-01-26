//
//  MKListOptionView.h
//  YangDongXi
//
//  Created by windy on 15/4/27.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    VESortByComprehensiveDesc                   = 0,
    VESortBySalesDesc                           = 1,
    VESortByPriceDesc                           = 2,
    VESortByTemplate                            = 3,

} VESortBy;

@class MKListOptionView;

@protocol MKListOptionViewDelegate <NSObject>

-(void)didPressTemplateToDouble:(BOOL)isDoubleTemplate;

- (void)didPressListOrdering:(VESortBy)sortBy withTag:(NSInteger)tag;
@end

@interface MKListOptionView : UIView

@property (assign, nonatomic) VESortBy sortBy;

@property (assign, nonatomic) NSInteger btnTag;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topSeperatorLineHeight;
@property (weak, nonatomic) IBOutlet UIView *backNewView;
@property (nonatomic, weak) IBOutlet UIButton *salesButton;


- (IBAction)sortByButtonClick:(id)sender;


@property (weak,nonatomic) id<MKListOptionViewDelegate>delegate;

+ (id)loadFromNib;

@end
