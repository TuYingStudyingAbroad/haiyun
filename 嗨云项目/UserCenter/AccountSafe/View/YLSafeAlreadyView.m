//
//  YLSafeAlreadyView.m
//  嗨云项目
//
//  Created by YanLu on 16/5/16.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "YLSafeAlreadyView.h"
#import "HYLoginTextFieldView.h"

@interface YLSafeAlreadyView ()

/**
 *  顶部View
 */
@property (nonatomic,strong) UIView *topView;
/**
 *  图片
 */
@property (nonatomic,strong) UIImageView *topImageView;
/**
 *  name
 */
@property (nonatomic,strong) UILabel *topLabel;

@property (nonatomic, strong) UIView *bottomView;
/**
 *  姓名
 */
@property (nonatomic,strong) HYLoginTextFieldView *nameView;
/**
 *  身份证
 */
@property (nonatomic,strong) HYLoginTextFieldView *cardView;

@end

@implementation YLSafeAlreadyView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectIsNull(frame)||CGRectIsEmpty(frame))
        return;
    
    CGRect rect = CGRectMake(0, 0, frame.size.width, 133.0f);
    if ( _topView == nil )
    {
        _topView = NewObject(UIView);
        _topView.frame = rect;
        _topView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_topView];
    }else
    {
        _topView.frame = rect;
    }
    
    
    rect.origin.y = 33.0f;
    rect.size.width = 42.0f;
    rect.size.height = rect.size.width;
    rect.origin.x = (Main_Screen_Width - rect.size.width)/2.0f;
    if ( _topImageView == nil )
    {
        _topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HYSaferenzhengchenggong"]];
        _topImageView.frame = rect;
        [self addSubview:_topImageView];
    }else
    {
        _topImageView.frame = rect;
    }
    
    rect.origin.y += rect.size.height+15.0f;
    rect.size.height = 20.0f;
    rect.size.width = Main_Screen_Width;
    rect.origin.x = 0.0f;
    if ( _topLabel == nil )
    {
        _topLabel = NewObject(UILabel);
        _topLabel.frame = rect;
        _topLabel.backgroundColor = [UIColor clearColor];
        _topLabel.text = @"您已通过实名认证";
        _topLabel.font = [UIFont systemFontOfSize:15.0f];
        _topLabel.textColor = kHEXCOLOR(0x05be03);
        _topLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_topLabel];
 
    }else
    {
        _topLabel.frame = rect;
    }
    
    rect.origin.y = _topView.frame.origin.y + _topView.frame.size.height + 10.0f;
    rect.size.height = 88.0f;
    if ( _bottomView == nil ) {
        _bottomView = NewObject(UIView);
        _bottomView.frame = rect;
        _bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bottomView];
    }else
    {
        _bottomView.frame = rect;
    }
    
    rect.origin.x = 10.0f;
    rect.size.height = 44.0f;
    rect.size.width = frame.size.width - 2*rect.origin.x;
    if ( _nameView == nil ) {
        _nameView = NewObject(HYLoginTextFieldView);
        _nameView.iconImageName = @"HYSafeyonghuming";
        _nameView.textIsEnabled = NO;
        _nameView.secureTextEntry = NO;
        _nameView.textName = self.name;
        _nameView.textFont = [UIFont systemFontOfSize:14.0f];
        _nameView.textColor = kHEXCOLOR(0x999999);
        _nameView.frame = rect;
        [self addSubview:_nameView];
    }else{
        _nameView.frame = rect;
    }
    
    rect.origin.y += rect.size.height;
    if ( _cardView == nil )
    {
        _cardView = NewObject(HYLoginTextFieldView);
        _cardView.iconImageName = @"HYSafeshenfenzheng";
        _cardView.textIsEnabled = NO;
        _cardView.secureTextEntry = NO;
        NSString *strPad = @"**************************************";
        _cardView.textName = [self.cardId stringByReplacingCharactersInRange:NSMakeRange(1, self.cardId.length-2) withString:[strPad substringWithRange:NSMakeRange(0,self.cardId.length-2)]];
        _cardView.textFont = [UIFont systemFontOfSize:14.0f];
        _cardView.textColor = kHEXCOLOR(0x999999);
        _cardView.bottomHide = YES;
        _cardView.frame = rect;
        [self addSubview:_cardView];
    }else
    {
        _cardView.frame = rect;
    }
}

@end
