//
//  FirstImageViewShowCell.m
//  嗨云项目
//
//  Created by DY on 2016/12/20.
//  Copyright © 2016年 haiyun. All rights reserved.
//

#import "FirstImageViewShowCell.h"
#import <UIButton+WebCache.h>

@interface FirstImageViewShowCell()

@property (nonatomic, strong) UIButton *showImageBtn;
@property (nonatomic,strong)MKMarketingObject * itemInformation;

@end

@implementation FirstImageViewShowCell

-(void)updateWithEntryObject:(MKMarketingComponentObject *)object{
    [super updateWithEntryObject:object];
    
    if ( object.values.count <=0 ) {
        return;
    }
    if (self.showImageBtn == nil ) {
        self.showImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.showImageBtn.backgroundColor = [UIColor clearColor];
        [self.showImageBtn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.showImageBtn];
    }
    
    self.itemInformation  = [object.values objectAtIndex:0];
    self.showImageBtn.frame = CGRectMake(0, 0, Main_Screen_Width, ([self.itemInformation.height floatValue]/[self.itemInformation.width floatValue])*Main_Screen_Width);
    [self.showImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:self.itemInformation.imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_320x130"]];
    
}

-(void)onClickBtn:(id)sender
{
    if ( sender == self.showImageBtn )
    {
        if (self.itemInformation && self.delegate && [self.delegate respondsToSelector:@selector(marketingCell:didClickWithUrl:)]) {
            [self.delegate marketingCell:self didClickWithUrl:self.itemInformation .targetUrl];
            
        }
        
    }
}
@end
