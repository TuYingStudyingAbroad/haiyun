//
//  MKMarketingWritingCell.m
//  嗨云项目
//
//  Created by 小辉 on 16/9/19.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKMarketingWritingCell.h"

@interface MKMarketingWritingCell()
{
    
}

@property (nonatomic,strong)MKMarketingWritingCellView * MKMarketingWritingView;


@end
@implementation MKMarketingWritingCell

-(void)updateWithEntryObject:(MKMarketingComponentObject *)object{
    [super updateWithEntryObject:object];
    if (self.MKMarketingWritingView == nil)
    {
        self.MKMarketingWritingView = [MKMarketingWritingCellView loadFromXib];
        
        [self.contentView addSubview:self.MKMarketingWritingView];
        
        [self.MKMarketingWritingView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
    }
    if (object.values.count > 0)
    {
        MKMarketingObject *ob = object.values[0];
        self.MKMarketingWritingView.topTitleLab.text=ob.categoryTitle;
        self.MKMarketingWritingView.bottomTitleLan.text=ob.subCategoryTitle;
    }
    
}



+(CGFloat)cellHeight{
    return 65;
}
@end
