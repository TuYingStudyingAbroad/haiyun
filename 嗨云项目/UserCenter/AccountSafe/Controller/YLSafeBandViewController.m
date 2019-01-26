//
//  YLSafeBandViewController.m
//  嗨云项目
//
//  Created by YanLu on 16/5/12.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "YLSafeBandViewController.h"
#import "HYSafeBandNumView.h"
#import "YLSafeAuthenticationViewController.h"
#import "PersonZLViewController.h"

@interface YLSafeBandViewController ()<HYBaseViewDelegate>
{
    HYSafeBandNumView *_pView;
}

@end

@implementation YLSafeBandViewController

-(void)dealloc
{
    _pView.baseDelegate = nil;
    _pView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setMyNavigation];
    self.view.backgroundColor = kHEXCOLOR(0xf5f5f5);
    [self initsubView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void) initsubView
{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    rect.size.height = self.view.frame.size.height - rect.origin.y;
    if ( _pView == nil)
    {
        _pView = NewObject(HYSafeBandNumView);
        _pView.backgroundColor = [UIColor clearColor];
        _pView.nsPhoneNum = self.nsPhoneNum;
        _pView.nsIsCard = self.nsIsCard;
        _pView.nsPhoneType = self.nsPhoneType;
        _pView.frame = rect;
        _pView.baseDelegate = self;
        [self.view addSubview:_pView];
    }
    else
    {
        _pView.frame = rect;
    }
}


- (void)setMyNavigation
{
    NSString *titleName = @"完成";
    if ( self.nsPhoneType == 1 )
    {
         self.title = @"修改手机号码";
        titleName = @"下一步";
    }else if (  self.nsPhoneType == 2  )
    {
        self.title = @"修改手机号码";
        titleName = @"完成";
    }
    else
    {
        self.title = @"绑定手机号码";
        titleName = @"完成";
    }
    // 完成
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithMJTitle:titleName target:self action:@selector(rightButton)];
}

-(void)rightButton
{
    if ( _pView )
    {
        [_pView onButtonClickRight];
    }
}
#pragma mark -HYBaseViewDelegate
-(void)OnPushController:(NSInteger)nMsgType wParam:(id)wParam
{
    switch (nMsgType)
    {
        case 0:
        {
            YLSafeAuthenticationViewController *pVc = [[YLSafeAuthenticationViewController alloc] init];
            pVc.typeCard = 1;
            [self.navigationController pushViewController:pVc animated:YES];

        }
            break;
        case 1:
        {
            for(UIViewController *pVc in self.navigationController.viewControllers)
            {
                if ([pVc isKindOfClass:[PersonZLViewController class]])
                {
                    [self.navigationController popToViewController:pVc animated:YES];
                    return;
                }
            }

        }
            break;
        case 2:
        {
            YLSafeBandViewController *pVc = [[YLSafeBandViewController alloc] init];
            pVc.nsPhoneType = 2;
            pVc.nsIsCard = YES;
            pVc.nsPhoneNum = nil;
            [self.navigationController pushViewController:pVc animated:YES];
            
        }
            break;
        case 4:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
