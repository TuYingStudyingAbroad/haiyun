//
//  HYShareActivityView.m
//  嗨云项目
//
//  Created by haiyun on 16/6/4.
//  Copyright © 2016年 杨鑫. All rights reserved.
//



#define ShareImageWidth  48.0f
#define ShareBtnTag 0x10000
#define ShareNum 4
#define ShareHeight  303.0f
#define ShareViewHeight 103.0f
#define ShareContentHeight 100.0f

#import "HYShareActivityView.h"


/********分享的按钮*******/

@interface HYShareButtonView()
{
    UIButton            *_shareBtn;
    UILabel             *_titleLabel;
}

@end

@implementation HYShareButtonView

-(instancetype)initWithFrame:(CGRect)frame
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
    
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    CGRect  rect = CGRectMake(0, 0, ShareImageWidth, ShareImageWidth);
    rect.origin.x = (frame.size.width - rect.size.width)/2.0f;
    
    if ( _shareBtn == nil )
    {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setBackgroundImage:[UIImage imageNamed:self.shareImage] forState:UIControlStateNormal];
        [_shareBtn setBackgroundImage:[UIImage imageNamed:self.shareImage] forState:UIControlStateHighlighted];
        _shareBtn.frame = rect;
        _shareBtn.backgroundColor = [UIColor clearColor];
        [_shareBtn addTarget:self action:@selector(OnButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_shareBtn];
    }else
    {
        _shareBtn.frame = rect;
    }
    rect.origin.y +=  rect.size.height + 3.0f;
    rect.size.width = frame.size.width;
    rect.origin.x = 0.0f;
    rect.size.height = 18.0f;
    if ( _titleLabel == nil )
    {
        _titleLabel = NewObject(UILabel);
        _titleLabel.frame = rect;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.text = self.shareTitle;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = kHEXCOLOR(0x999999);
        _titleLabel.font = [UIFont systemFontOfSize:11.0f];
        [self addSubview:_titleLabel];
    }
    else
    {
        _titleLabel.frame = rect;
    }
    
}

-(void)OnButton:(id)sender
{
    if ( sender == _shareBtn )
    {
        if ( _delegate && [_delegate respondsToSelector:@selector(onIconBtnPress:)])
        {
            [_delegate onIconBtnPress:self];
        }
    }
}

@end


@interface HYShareActivityView ()<HYShareButtonViewDelegate>
{
    NSMutableArray  *_imageArray;
    NSMutableArray  *_nameArray;
    NSMutableArray  *_buttonType;
    NSUInteger     _lines;//行数
    UILabel         *_titleLabel;
    UIView          *_shareBtnView;
    UIButton        *_closeBtn;
    UIButton        *_cancelBtn;
    UIView          *_lineView;
    UIView          *_line1View;
    
    HYShareContentView      *_shareContentView;
    BOOL            _shown;
    
}

@property (nonatomic,strong)HYShayeTypeBlocks reqTypeResult;

@property (nonatomic,copy) NSString *shareTitle;
@property (nonatomic,copy) NSString *sharePay;

@end

@implementation HYShareActivityView


- (instancetype)initWithButtons:(NSArray *)buttons
                          title:(NSString *)title
                            pay:(NSString *)pays
                 shareTypeBlock:(HYShayeTypeBlocks )shareType
{
    self = [super init];
    if ( self )
    {
        if ( _buttonType == nil )
        {
            _buttonType = [[NSMutableArray alloc] initWithArray:buttons];
        }else
        {
            [_buttonType removeAllObjects];
            [_buttonType addObjectsFromArray:buttons];
        }
        _shown = NO;
        self.reqTypeResult = shareType;
        [self initarray];
        self.shareTitle = title;
        self.sharePay = pays;
        _lines = _buttonType.count>4?2:1;
        [self setFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    }
    return self;
}
-(void)initarray
{
        if ( _imageArray == nil  )
        {
            _imageArray = [[NSMutableArray alloc] initWithArray:@[@"TypeWechatSession",@"TypeWechatTimeline",@"TypeSinaWeibo",@"TypeQZone",@"TypeCopy",@"TypeQQFriend",@"TypeToMain",@"TypeCallService",@"TypeSMS"]];
           
        }
        if ( _nameArray == nil )
        {
             _nameArray = [[NSMutableArray alloc] initWithArray:@[@"微信朋友",@"朋友圈",@"新浪微博",@"QQ空间",@"复制链接",@"QQ",@"去首页",@"联系客服",@"发短信"]];
        }
    self.shareTitle = @"分享至";
    self.sharePay = @"";
}
- (instancetype)initWithButtons:(NSArray *)buttons shareTypeBlock:(HYShayeTypeBlocks )shareType
{
    self = [super init];
    if ( self )
    {
        if ( _buttonType == nil )
        {
            _buttonType = [[NSMutableArray alloc] initWithArray:buttons];
        }else
        {
            [_buttonType removeAllObjects];
            [_buttonType addObjectsFromArray:buttons];
        }
        _shown = NO;
        self.reqTypeResult = shareType;
        [self initarray];
        _lines = _buttonType.count>4?2:1;
        [self setFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
    rect.size.height = Main_Screen_Height - ShareHeight + ShareViewHeight*(2-_lines);
    if ( ISNSStringValid(self.sharePay) )
    {
        rect.size.height -= ShareContentHeight;
    }
    if ( _closeBtn == nil )
    {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = rect;
        _closeBtn.backgroundColor = [UIColor clearColor];
        [_closeBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeBtn];
    }else
    {
        _closeBtn.frame = rect;
    }
    
    rect.origin.y += rect.size.height;
    rect.size.height = 40.0f;
    if ( _titleLabel == nil )
    {
        _titleLabel = NewObject(UILabel);
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.text = self.shareTitle;
        _titleLabel.textColor = kHEXCOLOR(0x252525);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [self addSubview:_titleLabel];
    }else
    {
        _titleLabel.frame = rect;
    }
    if ( ISNSStringValid(self.sharePay) )
    {
        rect.origin.y += rect.size.height;
        rect.size.height = ShareContentHeight;
        if ( _shareContentView == nil )
        {
            _shareContentView = NewObject(HYShareContentView);
            _shareContentView.sharePay = self.sharePay;
            _shareContentView.frame = rect;
            [self addSubview:_shareContentView];
        }else
        {
            _shareContentView.sharePay = self.sharePay;
            _shareContentView.frame = rect;
        }
    }else
    {
        if ( _shareContentView )
        {
            [_shareContentView removeFromSuperview];
        }
    }
    
    rect.origin.y += rect.size.height;
    rect.size.height = 1.0f;
    if ( _lineView == nil )
    {
        _lineView = NewObject(UIView);
        _lineView.frame = rect;
        _lineView.backgroundColor = kHEXCOLOR(0xebebeb);
        [self addSubview:_lineView];
    }else
    {
        _lineView.frame = rect;
    }
    
    rect.origin.y += rect.size.height;
    rect.size.height = ShareViewHeight*_lines;
    if ( _shareBtnView == nil )
    {
        _shareBtnView = NewObject(UIView);
        _shareBtnView.backgroundColor = [UIColor whiteColor];
        _shareBtnView.frame = rect;
        [self addSubview:_shareBtnView];
    }else
    {
        _shareBtnView.frame = rect;
    }
    CGFloat iconheight = ShareImageWidth+23.0f;
    CGFloat iconWidth = ShareImageWidth+10.0f;
    NSInteger nHcount = 4;
    CGFloat inconX = (frame.size.width - 4*iconWidth)/5.0f;
    CGRect btnrect = CGRectMake(0, rect.origin.y,iconWidth , iconheight);
    for (int i = 0 ; i< [_buttonType  count]; i++)
    {
        btnrect.origin.x = inconX*(i%nHcount) + iconWidth*(i%nHcount) + inconX;
        
        btnrect.origin.y = rect.origin.y + (i/nHcount)*(iconheight + 13.0f)+ 30.0f;
        NSUInteger type = [[_buttonType objectAtIndex:i] integerValue];
        HYShareButtonView * iconbtn = (HYShareButtonView *)[self viewWithTag:ShareBtnTag + type];
        if (iconbtn == nil)
        {
            iconbtn = NewObject(HYShareButtonView);
            iconbtn.tag = ShareBtnTag + type;
            iconbtn.shareImage = [_imageArray objectAtIndex:type];
            iconbtn.shareTitle = [_nameArray objectAtIndex:type];
            iconbtn.delegate = self;
            iconbtn.frame = btnrect;
            [self addSubview:iconbtn];
        }else
        {
            iconbtn.frame = btnrect;
        }
    }
    
    rect.size.height = 49.0f;
    rect.size.width = frame.size.width;
    rect.origin.x = 0;
    rect.origin.y = frame.size.height - rect.size.height;
    if ( _cancelBtn == nil )
    {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = rect;
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        [_cancelBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateHighlighted];
        [_cancelBtn setTitleColor:kHEXCOLOR(0x252525) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_cancelBtn setTitleColor:kHEXCOLOR(0x252525) forState:UIControlStateHighlighted];
        [self addSubview:_cancelBtn];
    }else
    {
        _cancelBtn.frame = rect;
    }
    
    rect.size.height = 8.0f;
    rect.origin.y -= rect.size.height;
    if ( _line1View == nil )
    {
        _line1View = NewObject(UIView);
        _line1View.backgroundColor = kHEXCOLOR(0xebebeb);
        _line1View.frame = rect;
        [self addSubview:_line1View];
    }else
    {
        _line1View.frame = rect;
    }
    
}

-(void)onButton:(id)sender
{
    if ( sender == _closeBtn )
    {
        [self hide];
    }
    else if ( sender == _cancelBtn )
    {
        [self hide];
    }
}
-(void)onIconBtnPress:(HYShareButtonView *)button
{
    NSInteger nSelect = ((UIView *)button).tag - ShareBtnTag;
    if ( self.reqTypeResult )
    {
        self.reqTypeResult(nSelect);
    }
}

- (void)show
{
    if (_shown)
    {
        return;
    }
    _shown = YES;
    
    self.frame = CGRectMake(0, Main_Screen_Height, Main_Screen_Width, Main_Screen_Height);
    self.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.5f animations:^
     {
         self.frame = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height);
         self.alpha = 1;

     } completion:^(BOOL finished) {
         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
     }];
}

- (void)hide
{
    if (!_shown)
    {
        return;
    }
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.5f animations:^
     {
         self.frame = CGRectMake(0, Main_Screen_Height, Main_Screen_Width, Main_Screen_Height);
     }
                     completion:^(BOOL finished)
     {
         _shown = NO;
         [self removeFromSuperview];
     }];
}


@end

@interface HYShareContentView ()
{
    UILabel     *_paysLabel;
    UILabel     *_contentLabel;
}

@end

@implementation HYShareContentView

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    self.backgroundColor = [UIColor whiteColor];
    CGRect rect = CGRectMake(0, 10.0f, frame.size.width, 26.0f);
    if ( _paysLabel == nil )
    {
        _paysLabel = NewObject(UILabel);
        _paysLabel.text = self.sharePay;
        _paysLabel.textColor = kHEXCOLOR(0xff2741);
        _paysLabel.textAlignment = NSTextAlignmentCenter;
        _paysLabel.font = [UIFont boldSystemFontOfSize:30.0f];
        _paysLabel.frame = rect;
        [self addSubview:_paysLabel];
    }else
    {
        _paysLabel.frame = rect;
    }
    
    rect.origin.y += rect.size.height+16.0f;
    rect.origin.x = 12.0f;
    rect.size.width = frame.size.width - 2*rect.origin.x;
    rect.size.height = 36.0f;
    if ( _contentLabel == nil )
    {
        _contentLabel = NewObject(UILabel);
        _contentLabel.text = [NSString stringWithFormat:@"小伙伴们从你分享的链接进入嗨云买买买，你就可以获得%@的收益奖励哦！心动就马上行动吧～",self.sharePay];
        _contentLabel.textColor = kHEXCOLOR(0x252525);
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
        _contentLabel.numberOfLines = 2;
        _contentLabel.frame = rect;
        [self addSubview:_contentLabel];
    }else
    {
        _contentLabel.frame = rect;
    }
    
}

@end

