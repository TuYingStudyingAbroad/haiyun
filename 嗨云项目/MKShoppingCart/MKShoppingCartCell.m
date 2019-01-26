//
//  MKShoppingCartCell.m
//  YangDongXi
//
//  Created by cocoa on 15/4/20.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKShoppingCartCell.h"
#import "UIColor+MKExtension.h"
#import "MBProgressHUD+MKExtension.h"
#import <UIImageView+WebCache.h>
#import <PureLayout.h>


@interface MKShoppingCartCell()

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *selectButtonLeading;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *selectButton2Leading;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *skuTop;


@property (nonatomic,strong) UILabel *imageIV;
@end


@implementation MKShoppingCartCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.numberEditView.plusEnableImage = [UIImage imageNamed:@"jia_kedian"];
    self.numberEditView.plusDisableImage = [UIImage imageNamed:@"jia_bukedian"];
    if ([self.numberEditView getNumber] == 1) {
        self.numberEditView.minusImageView.image = [UIImage imageNamed:@"shanchu"];
        self.numberEditView.minusEnableImage = [UIImage imageNamed:@"shanchu"];
        self.numberEditView.minusDisableImage = [UIImage imageNamed:@"shanchu"];
    }else {
        self.numberEditView.minusEnableImage = [UIImage imageNamed:@"minus_8x1"];
        self.numberEditView.minusDisableImage = [UIImage imageNamed:@"minus_gray_8x1"];
    }
    
    [self.numberEditView updateBorderColor:[UIColor colorWithHex:0xd5d5d5]];
}

- (void)switchSelectButton:(BOOL)oneToTwo animation:(BOOL)animation
{
//    if (animation)
//    {
//        [UIView animateWithDuration:0.25f animations:^
//        {
//            [self switchSelectButton:oneToTwo];
//            [self layoutIfNeeded];
//        }];
//    }
//    else
//    {
        [self switchSelectButton:oneToTwo];
//    }
}

- (void)switchSelectButton:(BOOL)oneToTwo
{
    if (oneToTwo)
    {
//        self.selectButtonLeading.constant = -22;
//        self.selectButton2Leading.constant = 22;
        self.numberEditView.hidden = YES;
        self.numSpace.constant = -100;
        self.deleteBtn.hidden = NO;
        self.deleteBtn.userInteractionEnabled = YES;
        self.limitLabel.hidden = YES;
    }
    else
    {
//        self.selectButtonLeading.constant = 22;
//        self.selectButton2Leading.constant = -22;
        self.numSpace.constant = 0;
        self.numberEditView.hidden = NO;
        self.deleteBtn.hidden = YES;
        self.limitLabel.hidden = NO;
    }
}
- (UILabel *)imageIV{
    if (!_imageIV) {
        self.imageIV = [[UILabel alloc] init];
    }
    return _imageIV;
}
+ (NSString*)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

- (void)updateContentWithItem:(MKCartItemObject *)item
{
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@",item.itemName];
    self.priceLabel.text = [MKBaseItemObject priceString:item.promotionPrice];
    self.skuLabel.text = item.skuSnapshot;

    //[self layoutIfNeeded];
    //判断是否有活动
    if (item.bizMark != NULL) {
        //使商品标题与商品图片水平对齐
        [self.titleLabel autoPinEdge:(ALEdgeTop) toEdge:(ALEdgeTop) ofView:self.thumbnailImageView withOffset:0];
    
        self.imageIV.hidden = NO;
        _imageIV.backgroundColor = [UIColor colorWithHex:0xff2741];
        if ([item.bizMark isEqualToString:@"ReachMultipleReduceTool"]) {
            _imageIV.text = @"活动";
            
        } else if ([item.bizMark isEqualToString:@"TimeRangeDiscount"]){
            _imageIV.text = @"限时购";
           
        }
        
        _imageIV.textColor = [UIColor colorWithHex:0xffffff];
        _imageIV.font = [UIFont systemFontOfSize:10];;
        _imageIV.textAlignment = NSTextAlignmentCenter;
        _imageIV.layer.cornerRadius = 2;
        _imageIV.layer.masksToBounds = YES;
        [self.contentView addSubview:_imageIV];
        //左对齐
        [_imageIV autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.skuLabel];
        //底部对齐
        [_imageIV autoPinEdge:(ALEdgeBottom) toEdge:(ALEdgeBottom) ofView:self.thumbnailImageView withOffset:0];
        [_imageIV autoSetDimension:ALDimensionWidth toSize:32];
        [_imageIV autoSetDimension:ALDimensionHeight toSize:15];
        //有活动时，使sku底部与标签顶部距离为6
        [self.skuLabel.superview removeConstraint:self.skuTop];
        [_imageIV autoPinEdge:(ALEdgeTop) toEdge:(ALEdgeBottom) ofView:self.skuLabel withOffset:6];
        [self.limitLabel autoPinEdge:(ALEdgeLeading) toEdge:(ALEdgeTrailing) ofView:_imageIV withOffset:5];
    }else{
        [self.skuLabel.superview removeConstraint:self.skuTop];
        [self.skuLabel autoPinEdge:(ALEdgeBottom) toEdge:(ALEdgeBottom) ofView:self.thumbnailImageView withOffset:0];
        [self.limitLabel autoPinEdge:(ALEdgeLeading) toEdge:(ALEdgeTrailing) ofView:self.skuLabel withOffset:5];
        self.imageIV.hidden = YES;
        [self.imageIV removeFromSuperview];
    }
    [self.numberEditView updateNumber:item.number];
    self.originalPriceLabel.text = [NSString stringWithFormat:@"￥%@",[MKBaseItemObject priceString:item.marketPrice]];
    self.originalPriceLabel.hidden = item.promotionPrice >= item.marketPrice;
     [self.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:item.iconUrl] placeholderImage:[UIImage imageNamed:@"placeholder_60x60"]];
    self.numberEditView.plusEnableImage = [UIImage imageNamed:@"jia_kedian"];
    self.numberEditView.plusDisableImage = [UIImage imageNamed:@"jia_bukedian"];
    self.limitLabel.hidden = YES;
    if (item.stockNum <= [self.numberEditView getNumber] && item.stockNum > 0) {
        self.limitLabel.text = @"库存不足或超限购量";
        self.limitLabel.hidden = NO;
        self.numberEditView.max = item.number;
    }
    else if(item.stockNum != 0 && item.stockNum > [self.numberEditView getNumber] ){
        self.limitLabel.text = @"";
        self.limitLabel.hidden = YES;
        self.numberEditView.max = item.stockNum;
    }
    if (item.saleMinNum && item.saleMinNum.integerValue > 1) {
        self.limitLabel.text = [NSString stringWithFormat:@"(%@件起购)",item.saleMinNum];
        self.numberEditView.min = self.itme.saleMinNum.integerValue;
    }
    if (item.saleMaxNum && item.saleMaxNum.integerValue != 0) {
        self.limitLabel.text = [NSString stringWithFormat:@"(限购%@件)",item.saleMaxNum];
        self.numberEditView.max = self.itme.saleMaxNum.integerValue;
    }
    if (item.status.integerValue == 2 || item.stockNum <= 0) {
        self.thumbnailImageView.image = [self getGrayImage:self.thumbnailImageView.image];
        item.status = @"2";
        self.selectButton.hidden = YES;
        self.statusLabel.hidden = NO;
        self.limitLabel.hidden = YES;
        self.statusDetailLabel.hidden = NO;
        self.numberEditView.max = item.number;
        item.isChecked = NO;
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:item.iconUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            UIImage *imagea = [self getGrayImage:image];
            self.thumbnailImageView.image = imagea;
        }];
    }else {
        self.selectButton.hidden = NO;
        self.statusLabel.hidden = YES;
        self.limitLabel.hidden = NO;
        self.statusDetailLabel.hidden = YES;
    }
    
    if ([self.numberEditView getNumber] == 1) {
        self.numberEditView.minusImageView.image = [UIImage imageNamed:@"shanchu"];
        self.numberEditView.minusEnableImage = [UIImage imageNamed:@"shanchu"];
        self.numberEditView.minusDisableImage = [UIImage imageNamed:@"shanchu"];
    }else {
        self.numberEditView.minusImageView.image = [UIImage imageNamed:@"minus_8x1"];
        self.numberEditView.minusEnableImage = [UIImage imageNamed:@"minus_8x1"];
        self.numberEditView.minusDisableImage = [UIImage imageNamed:@"minus_gray_8x1"];
    }
}

-(UIImage*)getGrayImage:(UIImage*)sourceImage
{
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    
    return grayImage;
}

@end
