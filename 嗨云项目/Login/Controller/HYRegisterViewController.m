//
//  HYRegisterViewController.m
//  嗨云项目
//
//  Created by YanLu on 16/5/10.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYRegisterViewController.h"
#import "HYRegisterView.h"
#import "HYAgreementViewController.h"
#import "HYSystemLoginMsg.h"
#import "HYAgreementObject.h"

@interface HYRegisterViewController ()<HYAgreementViewControllerDelegate>
{
    HYRegisterView  *_pView;
    HYAgreementViewController   *_argreeVc;
    NSMutableArray              *_agreeArr;
    NSString                    *_protocolIds;
}
@end

@implementation HYRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"注册";
    _protocolIds = @"";
    if ( _agreeArr == nil )
    {
        _agreeArr = [[NSMutableArray alloc] init];
    }else
    {
        [_agreeArr removeAllObjects];
    }
    [self initsubview];
    [self onRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
    
}
-(void)initsubview
{
    CGRect rect = CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height);
    rect.size.height -= rect.origin.x;
    if (_pView == nil)
    {
        _pView = [[HYRegisterView alloc] init];
        _pView.protocolIds = _protocolIds;
        _pView.frame = rect;
        [self.view addSubview:_pView];
    }else
    {
        _pView.protocolIds = _protocolIds;
        _pView.frame = rect;
    }
       
}
#pragma mark -请求查看协议协议
-(void)onRequest
{
    [HYSystemLoginMsg sendUserprotocol:@{@"pro_model":@"1"}
                               success:^(id sender) {
                                   if ( _agreeArr == nil )
                                   {
                                       _agreeArr = [[NSMutableArray alloc] init];
                                   }else
                                   {
                                       [_agreeArr removeAllObjects];
                                   }
                                   if ( [sender[@"posterity_list"] isKindOfClass:[NSArray class]] )
                                   {
                                   
                                       NSMutableArray *protocolIdArr = [NSMutableArray array];
                                       
                                       for( NSDictionary *dcis in sender[@"posterity_list"])
                                       {
                                           HYAgreementObject *agres = [HYAgreementObject objectWithDictionary:dcis];
                                           [protocolIdArr addObject:[NSString stringWithFormat:@"%@",agres.Id]];
                                           [_agreeArr addObject:agres];
                                       }
                                       if ( protocolIdArr.count )
                                       {
                                           _protocolIds = [@{@"id":protocolIdArr} JSONString];
                                           if ( _pView )
                                           {
                                               _pView.protocolIds = _protocolIds;
                                           }
                                       }
                                       [self createHYAgreementVc];
                                   }
                                   
    }];
}

-(void)createHYAgreementVc
{
    if ( _agreeArr.count )
    {
        _argreeVc = [[HYAgreementViewController alloc] init];
        _argreeVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        _argreeVc.titles = @"注册协议";
        _argreeVc.messages = @"【审慎阅读】您在申请注册流程中点击同意前，应当认真阅读以下协议。请您务必审慎阅读、充分理解协议中相关条款内容，其中包括：\n1、与您约定免除或限制责任的条款；\n2、与您约定法律适用和管辖的条款；\n3、其他以粗体下划线标识的重要条款。\n如您对协议有任何疑问，可向平台客服咨询。\n【特别提示】当您按照注册页面提示填写信息、阅读并同意协议且完成全部注册程序后，即表示您已充分阅读、理解并接受协议的全部内容。如您因平台服务与嗨云发生争议的，适用《嗨云平台推广合作协议》处理。阅读协议的过程中，如果您不同意相关协议或其中任何条款约定，您应立即停止注册程序。";
        _argreeVc.isClose = YES;
        _argreeVc.argreeArr = [[NSMutableArray alloc] initWithArray:_agreeArr];
        _argreeVc.delegate = self;
        [self.navigationController presentViewController:_argreeVc animated:NO completion:nil];
    }
}
#pragma mark -HYAgreementViewControllerDelegate
-(void)agreementViewClose:(HYAgreementViewController *)agreementView
{
    if ( agreementView == _argreeVc )
    {
        [self.navigationController popViewControllerAnimated:YES];
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
