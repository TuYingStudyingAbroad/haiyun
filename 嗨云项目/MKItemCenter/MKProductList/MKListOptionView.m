//
//  MKListOptionView.m
//  YangDongXi
//
//  Created by windy on 15/4/27.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKListOptionView.h"

@interface MKListOptionView ()

#define CardColorT 0xE85352


@property (weak, nonatomic) IBOutlet UIButton *comprehensiveButton;

@property (nonatomic, weak) IBOutlet UIButton *priceButton;

@property (weak,nonatomic) IBOutlet UIButton *templateButton;

@property (weak, nonatomic) IBOutlet UIButton *newsButton;

@property (nonatomic, weak) UIButton *sortByButton;

@property (nonatomic,assign)BOOL templateState;

@end

@implementation MKListOptionView

+ (id)loadFromNib
{
    NSString *xibName = NSStringFromClass([self class]);
    
    return [[[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.salesButton.selected = YES;
    self.sortByButton = self.salesButton;
    self.sortBy = VESortByComprehensiveDesc;
    [self.priceButton setTitle:@"价格" forState:UIControlStateNormal];
//    self.priceButton.titleLabel.font = [UIFont fontWithName:@"iconfont" size:14];
    [self.salesButton setTitleColor:[UIColor colorWithHex:CardColorT] forState:(UIControlStateSelected)];
    self.btnTag  = 0;
    self.sortBy = VESortBySalesDesc;
    self.templateState = YES;
}

- (IBAction)sortByButtonClick:(id)sender
{
    if (sender == self.templateButton)
    {
       self.templateState = !self.templateState;
        [self changeTempateImage:self.templateState];
        return;
    }
    
    if (sender == self.salesButton)
    {
        [sender setTitleColor:[UIColor colorWithHex:CardColorT] forState:(UIControlStateSelected)];
        self.btnTag = 0;
        self.sortBy = VESortBySalesDesc;
    }
    
    if (sender == self.priceButton)
    {
        [sender setTitleColor:[UIColor colorWithHex:CardColorT] forState:(UIControlStateSelected)];
        self.btnTag = (self.btnTag> 0 ? 0 : 1);
        self.sortBy = VESortByPriceDesc;
        
    }
    
    if (sender == self.newsButton) {
        [sender setTitleColor:[UIColor colorWithHex:CardColorT] forState:(UIControlStateSelected)];
        self.sortBy = VESortByTemplate;
        self.btnTag = 0;
    }
    
    if (sender == self.comprehensiveButton)
    {
        [sender setTitleColor:[UIColor colorWithHex:CardColorT] forState:(UIControlStateSelected)];
        self.btnTag = (self.btnTag> 0 ? 0 : 1);
        self.sortBy = VESortByComprehensiveDesc;
        
    }
    
    if (sender == self.sortByButton)
    {
        if ( sender != self.salesButton || sender != self.newsButton)
        {
            self.sortByButton.tag = !self.sortByButton.tag;
            [self changeSelectedImageByTag:self.sortByButton];
        }
    }else{
        self.sortByButton.selected = NO;
//        self.sortByButton.tag = (self.sortByButton == self.priceButton ? 0 : 1);
//       
//
        self.sortByButton = sender;
        self.sortByButton.selected = YES;
        self.sortByButton.tag=0;
        self.btnTag=1;
        [self changeSelectedImageByTag:self.sortByButton];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPressListOrdering:withTag:)]) {
        [self.delegate didPressListOrdering:self.sortBy withTag:self.btnTag];
    }
}

#pragma mark --
#pragma mark -- template button change method

-(void)changeTempateImage:(BOOL)state
{
    if(state)
    {
        [self.templateButton setImage:[UIImage imageNamed:@"single_row"] forState:UIControlStateNormal];
    }
    else
    {
        [self.templateButton setImage:[UIImage imageNamed:@"double_row"] forState:UIControlStateNormal];
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(didPressTemplateToDouble:)])
    {
        [self.delegate didPressTemplateToDouble:state];
    }
}

- (void)changeSelectedImageByTag:(UIButton *)button
{
    if ( button == self.salesButton||button == self.newsButton)
    {
        [button setTitleColor:[UIColor colorWithHex:CardColorT] forState:(UIControlStateSelected)];
        return;
    }
    else
    {
        
        NSString *imgs = button.tag == 1 ? @"product_down-red" : @"product_up-red";
        [button setImage:[UIImage imageNamed:imgs] forState:UIControlStateSelected];
//        button.titleLabel.font = [UIFont fontWithName:@"iconfont" size:14];
    }
}


@end
