//
//  HYShopInvitationView.m
//  嗨云项目
//
//  Created by haiyun on 16/8/23.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYShopInvitationView.h"


@interface HYShopInvitationView ()<HYShopIntvitationBottomViewDelegate>
{
    UIImageView     *_bannerImageView;
    
    HYShopIntvitationBottomView *_shareShopView;
    
    HYShopIntvitationBottomView *_shareRegView;

}

@end

@implementation HYShopInvitationView

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.backgroundColor = kHEXCOLOR(0xfffcda);
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    CGRect  rect = CGRectMake(0, 0, Main_Screen_Width, (320.0f/750.0f)*Main_Screen_Width);
    if ( _bannerImageView == nil )
    {
        _bannerImageView = NewObject(UIImageView);
        _bannerImageView.image = [UIImage imageNamed:@"yaoqingzhuanqian-banner"];
        _bannerImageView.frame = rect;
        [self.pBaseView addSubview:_bannerImageView];
    }else
    {
        _bannerImageView.frame = rect;
    }
    rect.origin.x = 10.0f;
    rect.origin.y += rect.size.height + 25.0f;
    rect.size.width = Main_Screen_Width - 2*rect.origin.x;
    rect.size.height = 148.0f;
    if ( _shareShopView == nil )
    {
        _shareShopView = NewObject(HYShopIntvitationBottomView);
        _shareShopView.layer.cornerRadius= 6.0f;
        _shareShopView.layer.masksToBounds = YES;
        _shareShopView.layer.borderColor = kHEXCOLOR(0xdd9e7d).CGColor;
        _shareShopView.layer.borderWidth = 0.5f;
        _shareShopView.shopTitle = @"邀请开店赚钱";
        _shareShopView.shopContent = @"点击邀请按钮，将您的开店邀请分享至微信、QQ等多个社交平台，成功邀请好友开店后立获收益哦";
        _shareShopView.delegate = self;
        _shareShopView.shopNumRight = @"人";
        _shareShopView.shopImageName = @"yaoqingkaidian";
        _shareShopView.shopNum = @"100";
        _shareShopView.frame = rect;
        [self.pBaseView addSubview:_shareShopView];
    }else
    {
        _shareShopView.frame = rect;
    }
    rect.origin.y += rect.size.height + 15.0f;
    if ( _shareRegView == nil )
    {
        _shareRegView = NewObject(HYShopIntvitationBottomView);
        _shareRegView.layer.cornerRadius= 6.0f;
        _shareRegView.layer.masksToBounds = YES;
        _shareRegView.layer.borderColor = kHEXCOLOR(0xdd9e7d).CGColor;
        _shareRegView.layer.borderWidth = 0.5f;
        _shareRegView.shopTitle = @"邀请注册赚钱";
        _shareRegView.shopContent = @"点击邀请按钮，将您的开店邀请分享至微信、QQ等多个社交平台，好友到嗨云并成功下单后，您可享受销售收益哦！";
        _shareRegView.shopNumRight = @"人注册";
        _shareRegView.shopImageName = @"yaoqingzhuce";
        _shareRegView.shopNum = @"8888888";
        _shareRegView.delegate = self;
        _shareRegView.frame = rect;
        [self.pBaseView addSubview:_shareRegView];
    }else
    {
        _shareRegView.frame = rect;
    }
    
    CGRect rectBaseView = _pBaseView.frame;
    rectBaseView.size.height = rect.origin.y + rect.size.height + 1.0f;
    _pBaseView.frame = rectBaseView;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.contentSize = CGSizeMake(0,_pBaseView.frame.size.height);
}

-(void)shopIntvitationBottomView:(HYShopIntvitationBottomView *)bottomView
                           types:(NSInteger)types
{
    if ( bottomView == _shareShopView )
    {
        if ( types == 1 )
        {
            if ( self.baseDelegate && [self.baseDelegate respondsToSelector:@selector(OnPushController:wParam:)]) {
                [self.baseDelegate OnPushController:0 wParam:@"0"];
            }
        }
        else if( types == 2 )
        {
            if ( self.baseDelegate && [self.baseDelegate respondsToSelector:@selector(OnPushController:wParam:)]) {
                [self.baseDelegate OnPushController:0 wParam:@"1"];
            }
        }
    }
    else if ( bottomView == _shareRegView )
    {
        if ( types == 1 )
        {
            
            if ( self.baseDelegate && [self.baseDelegate respondsToSelector:@selector(OnPushController:wParam:)]) {
                [self.baseDelegate OnPushController:1 wParam:@"1"];
            }

        }
    }
}
@end

/******************/
@interface HYShopIntvitationBottomView()
{
    UIImageView     *_rightImageView;
    
    UILabel         *_titleLabel;
    
    UILabel         *_numLabel;
    
    UIImageView     *_numImageView;
    
    UIButton        *_numBtn;
    
    UILabel         *_contentLabel;
    
    UIButton        *_shareBtn;
}

@end

@implementation HYShopIntvitationBottomView

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    CGRect  rect = CGRectMake(10.0f, 20.0f, 63.0f,63.0f);
    if ( _rightImageView == nil )
    {
        _rightImageView = NewObject(UIImageView);
        _rightImageView.image = [UIImage imageNamed:self.shopImageName];
        _rightImageView.frame = rect;
        [self addSubview:_rightImageView];
    }else
    {
        _rightImageView.frame = rect;
    }
    rect.origin.y += rect.size.height + 15.0f;
    rect.size.width = frame.size.width - 2*rect.origin.x;
    rect.size.height = frame.size.height - rect.origin.y-20.0f;
    if ( _contentLabel == nil )
    {
        _contentLabel = NewObject(UILabel);
        _contentLabel.text = self.shopContent;
        _contentLabel.numberOfLines = 2.0f;
        _contentLabel.frame = rect;
        _contentLabel.font = [UIFont systemFontOfSize:12.0f];
        _contentLabel.textColor = kHEXCOLOR(0xb43e01);
        [self addSubview:_contentLabel];
    }else
    {
        _contentLabel.frame = rect;
    }
    
    rect.origin.y = 28.0f;
    rect.origin.x = _rightImageView.frame.origin.x + _rightImageView.frame.size.width + 10.0f;
    rect.size.width = 120.0f;
    rect.size.height = 16.0f;
    if (_titleLabel == nil )
    {
        _titleLabel = NewObject(UILabel);
        _titleLabel.frame = rect;
        _titleLabel.text = self.shopTitle;
        _titleLabel.textColor = kHEXCOLOR(0x741513);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [self addSubview:_titleLabel];
    }else
    {
        _titleLabel.frame = rect;
    }
    
    rect.origin.y += rect.size.height+15.0f;
    rect.size.height = 20.0f;
    if (_numLabel == nil )
    {
        _numLabel = NewObject(UILabel);
        _numLabel.text = [NSString stringWithFormat:@"已邀请：%@%@",self.shopNum,self.shopNumRight];
        _numLabel.textColor = kHEXCOLOR(0xb43e01);
        _numLabel.textAlignment = NSTextAlignmentLeft;
        _numLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_numLabel];
        
        NSDictionary *attributesExtra = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],
                                          NSForegroundColorAttributeName: kHEXCOLOR(0xb43e01)};
        NSDictionary *attributesPrice = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0f],
                                          NSForegroundColorAttributeName:kHEXCOLOR(kRedColor)};
        
        NSAttributedString *attributedString = attributedText(@[@"已邀请：", self.shopNum, self.shopNumRight],@[attributesExtra,attributesPrice,attributesExtra]);
        
        CGRect rectNow = [attributedString boundingRectWithSize:CGSizeMake(Main_Screen_Width/2.0f, rect.size.height) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        rect.size.width = rectNow.size.width;
        rect.size.height = rectNow.size.height;
        _numLabel.frame = rect;
        _numLabel.attributedText = attributedString;

    }else
    {
        NSDictionary *attributesExtra = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],
                                          NSForegroundColorAttributeName: kHEXCOLOR(kRedColor)};
        NSDictionary *attributesPrice = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0f],//字号18
                                          NSForegroundColorAttributeName:kHEXCOLOR(kRedColor)};
        
        NSAttributedString *attributedString = attributedText(@[@"已邀请：", self.shopNum, self.shopNumRight],@[attributesExtra,attributesPrice,attributesExtra]);
        
        CGRect rectNow = [attributedString boundingRectWithSize:CGSizeMake(Main_Screen_Width/2.0f, rect.size.height) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        rect.size.width = rectNow.size.width;
        rect.size.height = rectNow.size.height;
        _numLabel.frame = rect;
        _numLabel.attributedText = attributedString;
    }
    
    if ( _numBtn == nil )
    {
        _numBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _numBtn.backgroundColor = [UIColor clearColor];
        _numBtn.frame = rect;
        [_numBtn addTarget:self action:@selector(OnButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_numBtn];
    }else
    {
        _numBtn.frame = rect;
    }
    
    rect.origin.x += rect.size.width + 3.0f;
    rect.origin.y += rect.size.height;
    rect.size.width = 6.0f;
    rect.size.height = 11.0f;
    rect.origin.y -= rect.size.height;
    rect.origin.y -= 3.0f;
    if ( _numImageView == nil )
    {
        _numImageView = NewObject(UIImageView);
        _numImageView.image = [UIImage imageNamed:@"yaoqingzhuanqian-qh"];
        _numImageView.frame = rect;
        [self addSubview:_numImageView];
    }else
    {
        _numImageView.frame = rect;
    }
    
    rect.size.width = 83.0f;
    rect.size.height = 34.0f;
    rect.origin.y = 20.0f;
    rect.origin.x = frame.size.width - rect.size.width - 10.0f;
    if ( _shareBtn == nil )
    {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareBtn.backgroundColor = kHEXCOLOR(0xff2741);
        [_shareBtn setTitle:@"邀请" forState:UIControlStateNormal];
        _shareBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_shareBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        _shareBtn.frame = rect;
        _shareBtn.layer.cornerRadius = 3.0;
        _shareBtn.layer.masksToBounds = YES;
        [_shareBtn addTarget:self action:@selector(OnButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_shareBtn];
    }else
    {
        _shareBtn.frame = rect;
    }
    
    
}

-(void)OnButton:(id)sender
{   NSInteger type = 0;
    if ( sender == _shareBtn )
    {
        type = 1;
    }else if( sender == _numBtn )
    {
        type = 2;
    }
    if ( _delegate && [_delegate respondsToSelector:@selector(shopIntvitationBottomView:types:)]) {
        [_delegate shopIntvitationBottomView:self types:type];
    }
}

-(void)setShopNumMsg:(NSString *)numMsg
{
    self.shopNum = numMsg;
    [self setFrame:self.frame];
}
@end
