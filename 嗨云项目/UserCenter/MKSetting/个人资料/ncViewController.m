//
//  ncViewController.m
//  嗨云项目
//
//  Created by kans on 16/5/11.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "ncViewController.h"
#import "MKUserCenter.h"
#import "MBProgressHUD+MKExtension.h"
#import "MKNetworking+BusinessExtension.h"
#define kMinLength 2
#define WXandQQMinLength 5
#define QQMaxLength 12
#define kMaxLength 15
#define WXMaxLength 20
@interface ncViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *ncTF;

@property (weak, nonatomic) IBOutlet UILabel *tsLabel;
@property (strong, nonatomic)NSString *bzStr;
@property (strong, nonatomic)NSString *bzStr1;
@property (assign, nonatomic)NSInteger minLangth;
@property (assign, nonatomic)NSInteger maxLangth;
@property (strong, nonatomic)NSString *emailRegex;

@end

@implementation ncViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.edgesForExtendedLayout= UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
//        self.tabBarController.tabBar.translucent = NO;
    }
    //self.title = @"修改昵称";
    
    self.ncTF.delegate = self;
    self.ncTF.clearButtonMode = UITextFieldViewModeWhileEditing;//清除按钮

    if (self.nickN != nil) {
        
        self.ncTF.text = [NSString stringWithFormat:@"%@",self.nickN];
    }
    
    
    if ([self.title isEqualToString:@"修改昵称"]) {
        
        self.ncTF.placeholder = @"请设置昵称";
        self.tsLabel.text = @"昵称由2-15个字节组成,支持汉字/英文/数字。";
        self.bzStr = @"昵称不可小于2个字节";
        self.bzStr1 = @"昵称仅支持汉字、英文、数字";
        self.minLangth = kMinLength;
        self.maxLangth = kMaxLength;
        self.emailRegex = @"^[a-zA-Z0-9\u4E00-\u9FA5]+$";
    }
    if ([self.title isEqualToString:@"微信号设置"]) {
        
       
        self.ncTF.placeholder = @"请设置微信号";
        self.tsLabel.text = @"微信号由5-20个字节组成,支持英文/数字/减号/下划线。";
        self.bzStr = @"微信号不可小于5个字节";
        self.bzStr1 = @"微信号仅支持英文、数字、减号、下划线";
        self.minLangth = WXandQQMinLength;
        self.maxLangth = WXMaxLength;
        self.emailRegex = @"^[A-Za-z0-9_-]+$";
    }
    if ([self.title isEqualToString:@"QQ号设置"]) {
        
        self.ncTF.placeholder = @"请设置QQ号";
        self.tsLabel.text = @"QQ号由5-12个字节组成,支持数字。";
        self.bzStr = @"QQ号不可小于5个字节";
        self.bzStr1 = @"QQ号仅支持数字";
        self.minLangth = WXandQQMinLength;
        self.maxLangth = QQMaxLength;
        //正则 仅支持数字
        self.emailRegex = @"^[0-9]*$";
    }

    self.view.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem= rightItem;
    //对实时键盘监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.ncTF];
    // Do any additional setup after loading the view from its nib.
}
-(void)saveBtnClick:(UIButton *)btn {
    
    [self.ncTF resignFirstResponder];
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", self.emailRegex];
    if (self.ncTF.text.length<self.minLangth) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:self.bzStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];

       
    } else
    {
        
    if ([emailTest evaluateWithObject:self.ncTF.text] ) {
        
        MBProgressHUD *hud = [MBProgressHUD showMessage:@"保存中" inView:self.view wait:YES];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        NSLog(@"输入格式正确");
        
        if ([self.title isEqualToString:@"修改昵称"]) {
            
            [param setObject:self.ncTF.text forKey:@"nick_name"];
            
            [MKNetworking MKSeniorPostApi:@"/user/nick_name/update" paramters:param completion:^(MKHttpResponse *response) {
                [hud hide:YES];
                if (response.errorMsg != nil)
                {
                    
                    [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
                    return ;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:MKUserInfoLoadSuccessNotification object:nil];
                });
                [MBProgressHUD showMessageIsWait:@"保存成功" wait:YES];
                
                [self.navigationController popViewControllerAnimated:YES];
                
                NSLog(@"%@",[response mkResponseData]);
            }];

        }
        if ([self.title isEqualToString:@"微信号设置"]) {
            
            [param setObject:self.ncTF.text forKey:@"wechat"];
            [param setObject:@"" forKey:@"qq_code"];
            //[param setObject:@"123456" forKey:@"user_id"];
            //[param setObject:self.ncTF.text forKey:@"user_id"];
            [MKNetworking MKSeniorPostApi:@"/user/userWechatAndQqCode/update" paramters:param completion:^(MKHttpResponse *response) {
                [hud hide:YES];
                if (response.errorMsg != nil)
                {
                    
                    [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
                    return ;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:MKUserInfoLoadSuccessNotification object:nil];
                });
                [MBProgressHUD showMessageIsWait:@"保存成功" wait:YES];
                
                [self.navigationController popViewControllerAnimated:YES];
                
                NSLog(@"%@",[response mkResponseData]);
            }];
            
            
        }
        if ([self.title isEqualToString:@"QQ号设置"]) {
            
            [param setObject:@"" forKey:@"wechat"];
            [param setObject:self.ncTF.text forKey:@"qq_code"];
            [MKNetworking MKSeniorPostApi:@"/user/userWechatAndQqCode/update" paramters:param completion:^(MKHttpResponse *response) {
                [hud hide:YES];
                if (response.errorMsg != nil)
                {
                    
                    [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
                    return ;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:MKUserInfoLoadSuccessNotification object:nil];
                });
                [MBProgressHUD showMessageIsWait:@"保存成功" wait:YES];
                
                [self.navigationController popViewControllerAnimated:YES];
                
                NSLog(@"%@",[response mkResponseData]);
            }];

            
        }
        
        
        
        
    }else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:self.bzStr1 delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        NSLog(@"昵称仅支持汉字、英文、数字");
        
        
    }
    }
}
//对键盘进行监听，使输入的字符长度不能超过最大输入长度
-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > self.maxLangth) {
                textField.text = [toBeString substringToIndex:self.maxLangth];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > self.maxLangth) {
            textField.text = [toBeString substringToIndex:self.maxLangth];
        }  
    }  
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.ncTF];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
