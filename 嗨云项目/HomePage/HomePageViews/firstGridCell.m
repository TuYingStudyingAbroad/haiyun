//
//  firstGridCell.m
//  嗨云项目
//
//  Created by 小辉 on 16/11/5.
//  Copyright © 2016年 haiyun. All rights reserved.
//

#import "firstGridCell.h"
#import <UIButton+WebCache.h>
#import "UIImage+ResizeMagick.h"
#import "MKFlagShared.h"
#import "MKGridBlockList.h"
#define Width  [UIScreen mainScreen].bounds.size.width

@interface firstGridCell()

@property (nonatomic,strong)MKMarketingObject * itemInformation;
@property (nonatomic,assign)CGFloat OnelineWidth;
@property (nonatomic,assign)CGFloat high ;
@property (nonatomic ,assign)NSInteger line;
@property (nonatomic,assign)NSInteger row;


@end


@implementation firstGridCell


-(void)updateWithEntryObject:(MKMarketingComponentObject *)object{
    for (UIView * v in self.contentView.subviews) {
        [v removeFromSuperview];
    }
    MKMarketingObject *itemInformation = [object.values objectAtIndex:0];

    
    
    self.line=itemInformation.gridColumn.integerValue;
    self.row=itemInformation.gridRow.integerValue;
    self.OnelineWidth=Width/itemInformation.gridColumn.integerValue;
    self.itemInformation=itemInformation;
  
    NSMutableArray *a = [NSMutableArray array];
    
    NSInteger index = 0;
    
    int allHeight = self.OnelineWidth*self.row;
    NSString * keyStr=[NSString stringWithFormat:@"%@%@",itemInformation.gridRow,itemInformation.gridColumn];
    
    if(![[MKFlagShared sharedInstance].GirdHeightDictionary objectForKey:keyStr])
    {
        [[MKFlagShared sharedInstance].GirdHeightDictionary setObject:[NSNumber numberWithInt:allHeight] forKey:keyStr];
    }

    
    for (MKGridBlockList *ob in itemInformation.gridList)
    {
        
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        
        bt.adjustsImageWhenHighlighted = NO;
        
//        [bt sd_setImageWithURL:[NSURL URLWithString:ob.imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_60x60"]];
         [bt sd_setBackgroundImageWithURL:[NSURL URLWithString:ob.imageUrl] forState:UIControlStateNormal];
        
        
//        bt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        
//        bt.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [bt addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        bt.tag = index ++;
        
        [a addObject:bt];
        NSInteger topx=ob.leftTopX.integerValue;
        NSInteger topy=ob.leftTopY.integerValue;
        NSInteger bottomx=ob.bottomRightX.integerValue;
        NSInteger bottomy=ob.bottomRightY.integerValue;
        
        bt.frame=CGRectMake(topx*self.OnelineWidth, topy*self.OnelineWidth,(bottomx-topx)*self.OnelineWidth, (bottomy-topy)*self.OnelineWidth);
        [self.contentView addSubview:bt];
        
        UILongPressGestureRecognizer *longPress =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(handleTableviewCellLongPressed:)];
        //代理
        longPress.minimumPressDuration = 1.0;
        //将长按手势添加到需要实现长按操作的视图里
        [bt addGestureRecognizer:longPress];
    }
    
    
  
}

//长按事件的实现方法

- (void)handleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        if ( [gestureRecognizer view].tag>=0 && [gestureRecognizer view].tag<self.itemInformation.gridList.count ){
            MKMarketingObject *item = [self.itemInformation.gridList objectAtIndex:[gestureRecognizer view].tag];
            if ( self.delegate && [self.delegate respondsToSelector:@selector(longTouchUpDownLoadImage:)]) {
                [self.delegate longTouchUpDownLoadImage:item.imageUrl];
            }
        }
    }
    
}


- (void)buttonClick:(UIButton *)button
{

    if ( button.tag>=0 && button.tag<self.itemInformation.gridList.count )
    {
        MKMarketingObject *item = [self.itemInformation.gridList objectAtIndex:button.tag];
        if ( self.delegate && [self.delegate respondsToSelector:@selector(marketingCell:didClickWithUrl:)]) {
            [self.delegate marketingCell:self didClickWithUrl:item.targetUrl];

        }
        
    }
  
}




@end
