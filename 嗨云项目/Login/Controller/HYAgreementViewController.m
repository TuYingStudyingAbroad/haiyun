//
//  HYAgreementViewController.m
//  嗨云项目
//
//  Created by haiyun on 2016/10/24.
//  Copyright © 2016年 haiyun. All rights reserved.
//

#import "HYAgreementViewController.h"
#import "UIAgreeWebViewController.h"
#import "HYAgreementObject.h"
#import "HYSystemLoginMsg.h"

@interface HYAgreementViewController ()
{
    UIScrollView            *_bgView;
    
    UILabel                *_titleLabel;
    
    UILabel                 *_mesLabel;
    
    UIButton                *_sureBtn;
    
    UIButton                *_closeBtn;

}

@property (nonatomic, strong) MKAccountInfo *accountInfo;

@end

@implementation HYAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    [self initsubView];
    if ( !self.isClose )
    {
        self.accountInfo = getUserCenter.accountInfo;
        [getUserCenter clearData];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    
}
-(void)initsubView
{
    if ( _bgView == nil )
    {
        _bgView = NewObject(UIScrollView);
        _bgView.frame = CGRectMake(0, Main_Screen_Height, Main_Screen_Width-20, 161.0f)
        ;
        _bgView.backgroundColor = [UIColor whiteColor];
    }else
    {
        _bgView.frame = CGRectMake(0, Main_Screen_Height, Main_Screen_Width-20, 161.0f);
    }
    
    if ( _closeBtn == nil )
    {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _closeBtn.frame = CGRectMake(Main_Screen_Width-46, 10, 20, 20);
        [_closeBtn setImage:[UIImage imageNamed:@"X_19x19"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.hidden = !self.isClose;
        [_bgView addSubview:_closeBtn];
    }else
    {
        _closeBtn.hidden = !self.isClose;
        _closeBtn.frame = CGRectMake(Main_Screen_Width-46, 10, 20, 20);
 
    }
    CGRect rect = CGRectMake(10, 16, Main_Screen_Width-40.0f, 20);
    if ( _titleLabel==nil )
    {
        _titleLabel = NewObject(UILabel);
        _titleLabel.frame = rect;
        _titleLabel.text = self.titles;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_bgView addSubview:_titleLabel];
    }else
    {
        _titleLabel.frame = rect;
    }
    
    rect.origin.x = 20.0f;
    rect.origin.y += rect.size.height + 12.0f;
    rect.size.width = Main_Screen_Width-60.0f;
    rect.size.height = GetHeightOfString(self.messages, rect.size.width, [UIFont systemFontOfSize:13.0f]);
    if ( _mesLabel==nil )
    {
        _mesLabel = NewObject(UILabel);
        _mesLabel.frame = rect;
        _mesLabel.text = self.messages;
        _mesLabel.font = [UIFont systemFontOfSize:13.0f];
        _mesLabel.numberOfLines = 0;
        _mesLabel.textColor = [UIColor grayColor];
        [_bgView addSubview:_mesLabel];
    }else
    {
        _mesLabel.frame = rect;
    }

    NSInteger tags = 0;
    for( HYAgreementObject *agrees in self.argreeArr )
    {
        rect.origin.y += rect.size.height + 12.0f;
        rect.size.height = 20.0f;
        tags ++;
        UIButton *arrBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        arrBtn.frame = rect;
        arrBtn.backgroundColor = [UIColor clearColor];
        [arrBtn setTitle:agrees.proName forState:UIControlStateNormal];
        arrBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        arrBtn.tag = tags;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:agrees.proName];
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [str length])];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [str length])];  //设置颜色
        [arrBtn setAttributedTitle:str forState:UIControlStateNormal];
        [arrBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:arrBtn];
    }
    
    rect.origin.y += rect.size.height + 12.0f;
    rect.origin.x = 10.0f;
    rect.size.height = 35.0f;
    rect.size.width = Main_Screen_Width-40.0f;
    if (_sureBtn == nil )
    {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _sureBtn.frame = rect;
        _sureBtn.backgroundColor = kHEXCOLOR(kRedColor);
        [_sureBtn setTitle:@"同意协议" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureBtn.tag = 0;
        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.layer.cornerRadius = 6.0;
        [_sureBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_sureBtn];
    }else
    {
        _sureBtn.frame = rect;
    }
   
    
    rect.size.height += rect.origin.y+20.0f;
    rect.size.width = Main_Screen_Width - 20.0f;
    rect.origin.x = 10.0f;
    rect.origin.y = 0;
    _bgView.frame = rect;
    _bgView.showsVerticalScrollIndicator = NO;
    _bgView.showsHorizontalScrollIndicator = NO;
    _bgView.contentSize = CGSizeMake(0,_bgView.frame.size.height);
    [self.view addSubview:_bgView];
    _bgView.layer.position = self.view.center;

}


-(void)onButton:(id)sender
{
    if ( sender == _sureBtn )
    {
        NSMutableArray *prArr = [NSMutableArray array];
        for( HYAgreementObject *agrees in self.argreeArr )
        {
            [prArr addObject:[NSString stringWithFormat:@"%@",agrees.Id]];
        }
        
        if ( !self.isClose && prArr.count )
        {
            [HYSystemLoginMsg createHaikeProtocol:@{@"protocolIds":[@{@"id":prArr} JSONString],@"user_id":self.accountInfo.userId}
                                          success:^{
                [getUserCenter loginWithAccountInfo:self.accountInfo];
                [self dismissViewControllerAnimated:NO completion:nil];

            }];
        }else
        {
            if ( self.accountInfo )
            {
                [getUserCenter loginWithAccountInfo:self.accountInfo];
            }
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }
    else if ( sender == _closeBtn )
    {
        [self dismissViewControllerAnimated:NO completion:^{
            if ( _delegate && [_delegate respondsToSelector:@selector(agreementViewClose:)]) {
                [_delegate agreementViewClose:self];
            }
        }];
    }
    else
    {
        UIButton *btn = (UIButton *)sender;
        if ( btn.tag>0 && btn.tag <= self.argreeArr.count )
        {
            HYAgreementObject *agrees = self.argreeArr[btn.tag-1];
            UIAgreeWebViewController *vc = [[UIAgreeWebViewController alloc] init];
            vc.titles = agrees.proName;
            vc.htmlUrl = agrees.proContent;
            HYNavigationController *navs = [[HYNavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:navs animated:NO completion:nil];
        }
    }
    
}


@end
