//
//  MKProductCollectionListCell.m
//  YangDongXi
//
//  Created by Constance Yang on 25/07/2015.
//  Copyright (c) 2015 yangdongxi. All rights reserved.
//

#import "MKProductCollectionListCell.h"
#import <UIImageView+WebCache.h>
#import "NSString+MKExtension.h"
#import "MKProductCollectionView.h"
#import "MKMarketingListItem.h"
#import "MKUrlGuide.h"
#import "MKFlagShared.h"
#import "MKMarketingFlagObject.h"
#import "UIColor+MKExtension.h"
#import "MarketActivityObject.h"
@interface MKProductCollectionListCell()

@property (nonatomic, strong) IBOutlet UIView *discountLabelBackground;

@property (nonatomic, strong) MKMarketingComponentObject *entryObject;

@property (strong,nonatomic) MKProductCollectionView *leftCollectionView;

@property (strong,nonatomic) MKProductCollectionView *rightCollectionView;

@property (weak,nonatomic) IBOutlet UIImageView *leftImageView;

@property (weak,nonatomic) IBOutlet UIImageView *rightImageView;

@property (strong,nonatomic) NSArray *dataArray;

@end

@implementation MKProductCollectionListCell

#pragma mark--
#pragma mark -- override getter method

-(NSArray *)dataArray
{
    if(!_dataArray)
    {
        _dataArray = [[NSArray alloc]init];
    }
    
    return _dataArray;
}

-(MKProductCollectionView *)leftCollectionView
{
    if(!_leftCollectionView)
    {
        _leftCollectionView = [MKProductCollectionView loadFromXib];
    }
    return _leftCollectionView;
}

-(MKProductCollectionView *)rightCollectionView
{
    if(!_rightCollectionView)
    {
        _rightCollectionView = [MKProductCollectionView loadFromXib];
    }
    return _rightCollectionView;
}

#pragma mark --
#pragma mark -- life cycle method

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self initialMethod];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initialMethod];
}

#pragma mark --
#pragma mark -- initial method

-(void)initialMethod
{
    [self.contentView addSubview:self.leftCollectionView];
    
    [self.contentView addSubview:self.rightCollectionView];
    
    self.leftCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.rightCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *constaint = [NSLayoutConstraint constraintWithItem:self.leftCollectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:6.0];
    
    [self.contentView addConstraint:constaint];
    
    constaint = [NSLayoutConstraint constraintWithItem:self.leftCollectionView  attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:3.0];
    
    [self.contentView addConstraint:constaint];
    
    constaint = [NSLayoutConstraint constraintWithItem:self.leftCollectionView  attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-3.0];
    
    [self.contentView addConstraint:constaint];
    
    constaint = [NSLayoutConstraint constraintWithItem:self.rightCollectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:3.0];
    
    [self.contentView addConstraint:constaint];
    
    constaint = [NSLayoutConstraint constraintWithItem:self.rightCollectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-3.0];
    
    [self.contentView addConstraint:constaint];
    
    constaint = [NSLayoutConstraint constraintWithItem:self.rightCollectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-6.0];
    
    [self.contentView addConstraint:constaint];
    
    constaint = [NSLayoutConstraint constraintWithItem:self.leftCollectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.rightCollectionView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-6.0];
    
    [self.contentView addConstraint:constaint];
    
    constaint = [NSLayoutConstraint constraintWithItem:self.leftCollectionView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.rightCollectionView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    
    [self.contentView addConstraint:constaint];
    
    self.bottomSeperatorLine.hidden = YES;
}

+ (CGFloat)cellHeight
{
    return 265;
}

- (void)updateWithArray:(NSArray *)objectsArray
{
    NSInteger itemCount = MIN(2, objectsArray.count);
    
    self.dataArray = objectsArray;
    
    self.rightImageView.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
    
    self.leftImageView.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
    
    for (int index = 0; index < itemCount; index ++)
    {
        MKItemObject *item = [objectsArray objectAtIndex:index];
        
        MKProductCollectionView *currentCollectionView = nil;
        
        if(index == 0)
        {
            currentCollectionView = self.leftCollectionView;
            
        }
        else
        {
            currentCollectionView = self.rightCollectionView;
            
        }
        
        //判断活动标签是否展示
        if (item.onSale == 1) {
            currentCollectionView.activityMarkView.hidden = NO;
        }else {
            currentCollectionView.activityMarkView.hidden = YES;
        }

        NSArray *market_activity_list=item.marketActivityList;
        if (market_activity_list.count) {
            for (NSDictionary *MarketActivityObjectDic  in market_activity_list) {
                MarketActivityObject * MarketActivityOBJ=[MarketActivityObject objectWithDictionary:MarketActivityObjectDic];
                if ([MarketActivityOBJ.toolCode isEqualToString:@"TimeRangeDiscount"]) {
                    if ([MarketActivityOBJ.limitTagStatus isEqualToString:@"1"]) {
                        
                        currentCollectionView.limitTimeLab.backgroundColor=[UIColor colorWithHexString:@"FF7B7B"];
                        
                    }else{
                        currentCollectionView.limitTimeLab.backgroundColor=[UIColor colorWithHexString:@"999999"];
                    }
                    if ([MarketActivityOBJ.limitTagStatus isEqualToString:@"3"]) {
                         currentCollectionView.limitTimeLab.hidden=YES;
                    }
                    currentCollectionView.limitTimeLab.text=MarketActivityOBJ.activityTag;
                  
                }else{
                    currentCollectionView.limitTimeLab.hidden=YES;
                }
                
                if(MarketActivityOBJ.icon && MarketActivityOBJ.icon > 0)
                {
                    currentCollectionView.cornerImageView.hidden = NO;
                    
                    [currentCollectionView.cornerImageView sd_setImageWithURL:[NSURL URLWithString:MarketActivityOBJ.icon] placeholderImage:[UIImage imageNamed:@"placeholder_80x80"]];
                    
                }
                else
                {
                    currentCollectionView.cornerImageView.hidden = YES;
                }
                
           }
        
        }else{
            currentCollectionView.limitTimeLab.hidden=YES;
            currentCollectionView.cornerImageView.hidden = YES;
    }
        
        
        
        if(item.corner_icon_url && item.corner_icon_url.length > 0)
        {
            currentCollectionView.shuangshuangJieImagV.hidden = NO;
            
            [currentCollectionView.shuangshuangJieImagV sd_setImageWithURL:[NSURL URLWithString:item.corner_icon_url] placeholderImage:[UIImage imageNamed:@"placeholder_80x80"]];
            
        }
        else
        {
            currentCollectionView.shuangshuangJieImagV.hidden = YES;
        }

        
        if(item.supply_base && item.supply_base.length > 0)
        {
            MKMarketingFlagObject *object =  [[MKFlagShared sharedInstance].flagDictionary objectForKey:item.supply_base];
            
            if(object && object.icon_url)
            {
                NSString *imageLink = object.icon_url;
                [currentCollectionView.flagImageView sd_setImageWithURL:[NSURL URLWithString:imageLink] placeholderImage:[UIImage imageNamed:@"placeholder_80x80"]];
                currentCollectionView.flagImageView.hidden = NO;
                currentCollectionView.nameLabel.text = [NSString stringWithFormat:@"      %@",item.itemName];
            }
            else
            {
                currentCollectionView.flagImageView.hidden = YES;
                
                currentCollectionView.nameLabel.text = [NSString stringWithFormat:@"%@",item.itemName];
            }
        }
        else
        {
            currentCollectionView.flagImageView.hidden = YES;
            
            currentCollectionView.nameLabel.text = [NSString stringWithFormat:@"%@",item.itemName];
        }
        
        currentCollectionView.tag = index;
        
        [currentCollectionView.iconImageView sd_setImageWithURL:[NSURL URLWithString:item.iconUrl] placeholderImage:[UIImage imageNamed:@"placeholder_80x80"]];
        
        if (item.stockStatus == 0) {
            currentCollectionView.statusLabel.hidden = NO
            ;
        }else {
            currentCollectionView.statusLabel.hidden = YES
            ;
        }
        
        [currentCollectionView.button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        currentCollectionView.button.tag = index;
        
        [currentCollectionView updatePrice:item.wirelessPrice andMarketPrice:item.marketPrice];
        
    }
    
    if(itemCount == 1)
    {
        self.rightCollectionView.hidden = YES;
        
        self.rightImageView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    }
    else
    {
        self.rightCollectionView.hidden = NO;
        
    }
}

- (void)updateWithEntryObject:(MKMarketingComponentObject *)object
{
    
    MKMarketingObject *itemObject = [object.values objectAtIndex:0];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.entryObject = object;
    
    self.rightImageView.backgroundColor = [UIColor whiteColor];
    
    self.leftImageView.backgroundColor = [UIColor whiteColor];
    
    NSInteger itemCount = MIN(2, itemObject.productList.count);
    
    for (int index = 0; index < itemCount; index ++)
    {
        MKMarketingListItem *item = [itemObject.productList objectAtIndex:index];
            
        MKProductCollectionView *currentCollectionView = nil;
        
        if(index == 0)
        {
            currentCollectionView = self.leftCollectionView;
        }
        else
        {
            currentCollectionView = self.rightCollectionView;
        }
        
        currentCollectionView.cornerImageView.hidden = YES;
        currentCollectionView.statusLabel.hidden = YES;
        currentCollectionView.limitTimeLab.hidden=YES;
        currentCollectionView.tag = index;
        
        if(item.supplyPlace && item.supplyPlace.length > 0)
        {
            MKMarketingFlagObject *object =  [[MKFlagShared sharedInstance].flagDictionary objectForKey:item.supplyPlace];
            
            if(object && object.icon_url && object.icon_url.length > 0)
            {
                NSString *imageLink = object.icon_url;
                
                currentCollectionView.flagImageView.hidden = NO;
                
                [currentCollectionView.flagImageView sd_setImageWithURL:[NSURL URLWithString:imageLink]
                                                       placeholderImage:[UIImage imageNamed:@"placeholder_60x60"]];
                
                currentCollectionView.nameLabel.text = [NSString stringWithFormat:@"     %@",item.text];
            }
            else
            {
                currentCollectionView.flagImageView.hidden = YES;
                
                currentCollectionView.nameLabel.text = [NSString stringWithFormat:@"%@",item.text];
            }
            
        }
        else
        {
            currentCollectionView.flagImageView.hidden = YES;
            
            currentCollectionView.nameLabel.text = [NSString stringWithFormat:@"%@",item.text];
        }
            
        [currentCollectionView.iconImageView sd_setImageWithURL:[NSURL URLWithString:item.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder_107x125"]];
            
        [currentCollectionView.button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
        currentCollectionView.button.tag = index;
            
        [currentCollectionView updatePrice:item.wirelessPrice andMarketPrice:item.marketPrice];
        
    }
    
    if(itemCount == 1)
    {
        self.rightCollectionView.hidden = YES;
    }
    else
    {
        self.rightCollectionView.hidden = NO;
    }
}

#pragma mark --
#pragma mark -- button metho

-(void)buttonPressed:(UIButton *)button
{
    if(self.dataArray && self.dataArray.count)
    {
        MKItemObject *item = [self.dataArray objectAtIndex:button.tag];
        if(self.delegate && [self.delegate respondsToSelector:@selector(didSelect:)])
        {
            [self.delegate didSelect:item];
        }
        
    }
    else
    {
        MKMarketingObject *object = self.entryObject.values[0];
        
        MKMarketingListItem *item = [object.productList objectAtIndex:button.tag];
        
        [[MKUrlGuide commonGuide] guideForUrl:item.targetUrl];
    }
}

@end
