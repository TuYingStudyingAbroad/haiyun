//
//  PersonZLViewController.m
//  嗨云项目
//
//  Created by kans on 16/5/10.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "PersonZLViewController.h"

#import "ncViewController.h"
#import "AppDelegate.h"
#import <objc/runtime.h>
#import "MBProgressHUD+MKExtension.h"
#import "MKNetworking+BusinessExtension.h"
#import "personZLModel.h"
#import "UIImageView+WebCache.h"
#import "IQKeyboardManager.h"
#import "UIAlertView+Blocks.h"
#import "QYSDK.h"
#import "QYCommodityInfo.h"
#import "MKConsigneeListViewController.h"
#import "YLSafeBandViewController.h"
#import "YLSafeLoginPasswordViewController.h"
#import "YLSafePayPasswordController.h"
#import "YLSafeAlreadyCardController.h"
#import "YLSafeBandCardViewController.h"
#import "YLSafeTool.h"
#import "YLSafeUserInfo.h"
#import "HYMainNotDataView.h"
#import "UIAlertView+Blocks.h"
#import "HYPhoto.h"
#import "HYAccounSafeViewController.h"
#import "WXHBankCardViewController.h"
#import "PersonalInfo.h"
#import <AliyunOSSiOS/OSSService.h>

@interface PersonZLViewController ()<UITextFieldDelegate>
{
    
    
    YLSafeUserInfo          *_pSafeInfo;

}

//用户头像
@property (weak, nonatomic) IBOutlet UIImageView *personIV;
//昵称
@property (weak, nonatomic) IBOutlet UILabel *nameL;
//性别
@property (weak, nonatomic) IBOutlet UILabel *genderL;
//待定选择性别
@property (retain, nonatomic) NSString *genderStr;
//待定选择性别类型
@property (retain, nonatomic) NSString *gendertype;
//生日
@property (weak, nonatomic) IBOutlet UILabel *birthdayL;
//微信号
@property (weak, nonatomic) IBOutlet UILabel *wxHL;
//QQ号
@property (weak, nonatomic) IBOutlet UILabel *qqHL;

@property (weak, nonatomic) IBOutlet UILabel *lineL;

@property (weak, nonatomic) IBOutlet UILabel *lineL1;

@property (weak, nonatomic) IBOutlet UILabel *lineL2;

@property (retain, nonatomic)UITextField *TF;
@property (retain, nonatomic)UIView *customView;
@property (retain, nonatomic)UIView *customView1;
@property (retain, nonatomic)UIView *view1;
@property (retain, nonatomic)UIButton *cancelBtn;
@property (retain, nonatomic)UIButton *confirmBtn;
@property (retain, nonatomic)UIButton *mBtn;
@property (retain, nonatomic)UIButton *gBtn;
@property (retain, nonatomic)UILabel *line1;
@property (retain, nonatomic)UILabel *line2;
//从相册获取
@property (retain, nonatomic)UIButton *cxchp;
//拍照
@property (retain, nonatomic)UIButton *pz;
//取消
@property (retain, nonatomic)UIButton *qx;
//系统时间选择器
@property (retain, nonatomic)UIDatePicker *timePicker;
@property (retain, nonatomic)personZLModel *zlM;
@property (weak, nonatomic) IBOutlet UILabel *phoneRight;
@property (weak, nonatomic) IBOutlet UILabel *cardRight;
@property (weak, nonatomic) IBOutlet UILabel *payRight;

@property (weak, nonatomic) IBOutlet UILabel *lgoinRight;
@end

@implementation PersonZLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.edgesForExtendedLayout= UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    _lineL.backgroundColor = [UIColor colorWithHex:0xe8e8e8];
    _lineL1.backgroundColor = [UIColor colorWithHex:0xe8e8e8];
    _lineL2.backgroundColor = [UIColor colorWithHex:0xe8e8e8];
    self.view.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    self.TF.delegate = self;
    // 新建一个UITextField，位置及背景颜色随意写的。
    _TF = [[UITextField alloc] init];
    _TF.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_TF];
    // 自定义的view
    _customView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height*0.7)];
    _customView.backgroundColor = [UIColor blackColor];
    _customView.alpha = 0.4;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height*0.7)];
    
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(btnlClick:) forControlEvents:UIControlEventTouchUpInside];
    [_customView addSubview:btn];
    _TF.inputAccessoryView.hidden = YES; // 往自定义view中添加各种UI控件(以UIButton为例)
    _customView1 =[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height*0.3)];
    _customView1.backgroundColor = [UIColor whiteColor];
    _TF.inputView = _customView1;
    _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 60, 44)];
    _cancelBtn.backgroundColor = [UIColor clearColor];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-70, 0, 60, 44)];
    _confirmBtn.backgroundColor = [UIColor clearColor];
    [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [_confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(btnClicked1:) forControlEvents:UIControlEventTouchUpInside];
    
    _view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    _view1.backgroundColor = [UIColor colorWithHex:0xf8f8f8];
    
//    [_view1 addSubview:_cancelBtn];
//    [_view1 addSubview:_confirmBtn];
    // Do any additional setup after loading the view from its nib.
}
-(void)btnlClick:(UIButton *)btn {
    
    [self.TF resignFirstResponder];
    [_customView removeFromSuperview];
    [_cancelBtn removeFromSuperview];
    [_confirmBtn removeFromSuperview];
    [_timePicker removeFromSuperview];
    [_mBtn removeFromSuperview];
    [_gBtn removeFromSuperview];
    [_view1 removeFromSuperview];
    [_line1 removeFromSuperview];
    [_line2 removeFromSuperview];
    
    [_cxchp removeFromSuperview];
    [_pz removeFromSuperview];
    [_qx removeFromSuperview];
    
    self.genderStr = @"女";
    self.gendertype = @"0";
    NSLog(@"被点击了");
    
}
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    self.personIV.layer.cornerRadius = 20;
    
    self.personIV.layer.masksToBounds = YES;
    //获取个人信息
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [MKNetworking MKSeniorGetApi:@"/user/userOneselfInfo/query" paramters:param completion:^(MKHttpResponse *response) {
        
        [ hud hide:YES];
//        NSLog(@"%@",[response mkResponseData]);
        if (response.errorMsg != nil)
        {
            
            [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
            return ;
        }
  
        NSDictionary *dict = [response mkResponseData];
        
        self.zlM = [personZLModel objectWithDictionary:dict];
        
        //头像显示状态
        if (self.zlM.img_url != nil) {
            
            [self.personIV sd_setImageWithURL:[NSURL URLWithString:self.zlM.img_url] placeholderImage:[UIImage imageNamed:@"touxiang1"]];
                        
        }else {
            
            self.personIV.image = [UIImage imageNamed:@"touxiang1"];
            

        }
        if (self.zlM.nickName != nil) {
            
            if (self.zlM.nickName.length >5) {
                
                NSString *b = [self.zlM.nickName substringToIndex:5];
                self.nameL.text = [NSString stringWithFormat:@"%@...",b];
            }else{
                
                self.nameL.text = self.zlM.nickName;
            }
                
            
        }else {
            
            
            self.nameL.text = @"未设置";
            
        }
        //生日显示状态
        if (self.zlM.birthday != nil) {
            
            //转化时间格式 把@"May 27, 2016 12:00:00 AM"转成@“2016-05-27”
            NSLog(@"%@",self.zlM.birthday);
            NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
            NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];//设置时区
            [inputFormatter setTimeZone:timeZone];
            [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
            [inputFormatter setDateFormat:@"MMM d, yyyy HH:mm:ss aa"];
            NSDate* inputDate = [inputFormatter dateFromString:self.zlM.birthday];
            NSDateFormatter* toformatter = [[NSDateFormatter alloc] init];
            [toformatter setDateFormat:@"yyyy-MM-dd"];//设置目标时间字符串的格式
            NSString *targetTime = [toformatter stringFromDate:inputDate];//将时间转化成目标时间字符串
            NSLog(@"%@",targetTime);
            
            self.birthdayL.text = targetTime;
        } else {
            
            self.birthdayL.text = @"未设置";
        }
        //性别显示状态
        //self.gendertype = self.zlM.sex;
        if (self.zlM.sex.intValue == 0) {
            self.genderL.text = @"女";
         }else if (self.zlM.sex.intValue == 1) {
            self.genderL.text = @"男";
         }else {
            
            self.genderL.text = @"未设置";
        }
        
        if (self.zlM.wxNB != nil) {
            self.wxHL.text = self.zlM.wxNB;
        }else {
            
            
            self.wxHL.text = @"未设置";
            
        }
        
        if (self.zlM.qqNB != nil) {
            self.qqHL.text = self.zlM.qqNB;
        }else {
            
            
            self.qqHL.text = @"未设置";
            
        }

    }];
    
    
    //账户安全
    [self OnRequest];

}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}
#pragma mark -更改头像
- (IBAction)TXBtn:(id)sender {
    
    [_cxchp removeFromSuperview];
    [_pz removeFromSuperview];
    [_qx removeFromSuperview];
    [_customView removeFromSuperview];
    [_line1 removeFromSuperview];
    [_line2 removeFromSuperview];
    
    __weak typeof(self) weakSelf = self;
    [[HYPhoto getSharePhoto] getPhoto:sender Back:YES Image:^(UIImage *image, id sender)
     {
         if ( image )
         {
             NSData *data;
             if (UIImagePNGRepresentation(image) == nil)
             {
                 data = UIImageJPEGRepresentation(image, 0.5);
             }
             else
             {
                 data = UIImagePNGRepresentation(image);
             }
             
             [weakSelf uploadImageData:data];
             
             _personIV.image = [UIImage imageWithData:data];
         }
         
     }];

    
}

//更改昵称
- (IBAction)nameBtn:(id)sender {
    
    ncViewController *n = [[ncViewController alloc] init];
    n.nickN = self.zlM.nickName;
    n.title = @"修改昵称";
    [self.navigationController pushViewController:n animated:YES];
    
}

//更改性别
- (IBAction)genderBtn:(id)sender {
    self.gendertype = @"0";
    self.genderStr = @"女";
    [appDelegate.window addSubview:_customView];
     [_customView1 addSubview:_view1];
    [_customView1 addSubview:_cancelBtn];
    [_customView1 addSubview:_confirmBtn];
    
    _mBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, 40)];
    _mBtn.backgroundColor = [UIColor clearColor];
    [_mBtn setTitle:@"男" forState:UIControlStateNormal];
    [_mBtn setTitleColor:[UIColor colorWithHex:0x888888] forState:UIControlStateNormal];
    _mBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _mBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [_mBtn addTarget:self action:@selector(mBtnClicked:) forControlEvents:UIControlEventTouchDown];
    [_customView1 addSubview:_mBtn];
    
    _line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 109, _mBtn.frame.size.width, 1)];
    _line1.backgroundColor = [UIColor blackColor];
    _line1.alpha = 0.1;
    [_customView1 addSubview:_line1];
    _gBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 110, self.view.frame.size.width, 40)];
    _gBtn.backgroundColor = [UIColor clearColor];
    [_gBtn setTitle:@"女" forState:UIControlStateNormal];
    [_gBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _gBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _gBtn.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    [_gBtn addTarget:self action:@selector(gBtnClicked:) forControlEvents:UIControlEventTouchDown];
    [_customView1 addSubview:_gBtn];

    _line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 149, _gBtn.frame.size.width, 1)];
    _line2.backgroundColor = [UIColor blackColor];
    _line2.alpha = 0.1;
    [_customView1 addSubview:_line2];

    
    
    [self.TF becomeFirstResponder];
}

//更改生日
- (IBAction)birthdayBtn:(id)sender {
    
    self.genderStr = nil;
    self.gendertype = nil;
    [appDelegate.window addSubview:_customView];
    [_customView1 addSubview:_view1];
    [_customView1 addSubview:_cancelBtn];
    [_customView1 addSubview:_confirmBtn];
    
    _timePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 54, [UIScreen mainScreen].bounds.size.width, _customView1.frame.size.height-54)];
    _timePicker.datePickerMode = UIDatePickerModeDate;
    _timePicker.backgroundColor =[UIColor whiteColor];
    //设置最大日期为当前日期
    _timePicker.maximumDate = [NSDate date];
    //设置最小日期为倒退100年
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-100];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [_timePicker setMinimumDate:minDate];
   
    //设置为显示中文日期
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    _timePicker.locale = locale;
    [_customView1 addSubview:_timePicker];


    [self.TF becomeFirstResponder];
    
}
//更改微信号
- (IBAction)WXHBtn:(id)sender {
    
    ncViewController *n = [[ncViewController alloc] init];
    n.nickN = self.zlM.wxNB;
    n.title = @"微信号设置";
    [self.navigationController pushViewController:n animated:YES];
}
//更改qq号
- (IBAction)qqBtn:(id)sender {
    
    ncViewController *n = [[ncViewController alloc] init];
    n.nickN = self.zlM.qqNB;
    n.title = @"QQ号设置";
    [self.navigationController pushViewController:n animated:YES];
}
//地址管理入口
- (IBAction)adderssBtn:(id)sender {
    
    MKConsigneeListViewController *m = [MKConsigneeListViewController create];
    m.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:m animated:YES];
}
#pragma mark -绑定手机 0
- (IBAction)telphoneBtn:(id)sender {
    [self showSafeViewInfoType:0];
}
#pragma mark -实名认证
- (IBAction)smrzBtn:(id)sender {
    
    [self showSafeViewInfoType:3];
}
#pragma mark -支付密码
- (IBAction)zfmmBtn:(id)sender {
    [self showSafeViewInfoType:2];
}
#pragma mark -银行卡
- (IBAction)yhkBtn:(id)sender {
    if ( ![self isSeller] )
    {
        [self notSetSeller:@"只有嗨客才能设置银行卡"];
        return;
    }
    if ( ![self isAuthIdCardRealler] )
    {
        [self notAuthIdCardRealler];
        return;
    }
    [self bankCardList];
}
#pragma mark -登录密码
- (IBAction)dlmm:(id)sender {
    [self showSafeViewInfoType:1];
}

-(void)bankCardList{
    //判断买卖家和是否实名认证
    [MKNetworking MKSeniorGetApi:@"/myaccount/bank/list" paramters:nil completion:^(MKHttpResponse *response){
        NSLog(@"%@",response.responseDictionary);
        if (response.errorType == MKHttpErrorTypeLocal) {
            [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
            return ;
        }
        
        if ( response.originData ) {
            NSDictionary * getDic=[NSJSONSerialization JSONObjectWithData:response.originData options:NSJSONReadingMutableContainers error:nil];
            [self bankMangerDic:getDic]; 
        }
    }];
    
}

-(void)bankMangerDic:(NSDictionary *)dic{
    NSString * code=[NSString stringWithFormat:@"%@",dic[@"code"]];
    NSString * msg=dic[@"msg"];
    if ([code isEqualToString:@"32087"]) {
        [MBProgressHUD showMessageIsWait:msg wait:YES];
        return;
        
    }
    if ([code isEqualToString:@"32091"]) {
        [UIAlertView showWithTitle:@"提示" message:msg cancelButtonTitle:@"取消" otherButtonTitles:@[@"去认证"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            if (buttonIndex==0) {
                
            }else{
//                HYAccounSafeViewController * YLSafeBandCardViewVC=[[HYAccounSafeViewController alloc]init];
//                [self.navigationController pushViewController:YLSafeBandCardViewVC animated:YES];
                YLSafeBandCardViewController *pVc = [[YLSafeBandCardViewController alloc] init];
                [self.navigationController pushViewController:pVc animated:YES];
                
            }
            
        }];
        
        return;
    }
    if ([code isEqualToString:@"10000"]) {
        PersonalInfo * personlInfo=[PersonalInfo sharedModel];
        if (((NSArray*)dic[@"data"]).count) {
            NSDictionary * firstBankDic=dic[@"data"][0];
            personlInfo.nameStr=firstBankDic[@"bank_realname"];
            
            
        }
        
        WXHBankCardViewController * wxhBankCardVC=[[WXHBankCardViewController alloc]init];
        wxhBankCardVC.hidesBottomBarWhenPushed = YES;
        wxhBankCardVC.canSelected=NO;
        [self.navigationController pushViewController:wxhBankCardVC animated:YES];
        
    }
    
}


//取消按钮
-(void)btnClicked:(UIButton *)btn {
    
    [self.TF resignFirstResponder];
    
    //self.genderL.text = self.genderStr;
    [_cancelBtn removeFromSuperview];
    [_confirmBtn removeFromSuperview];
    [_timePicker removeFromSuperview];
    [_mBtn removeFromSuperview];
    [_gBtn removeFromSuperview];
    [_customView removeFromSuperview];
    [_view1 removeFromSuperview];
    [_line1 removeFromSuperview];
    [_line2 removeFromSuperview];
    self.genderStr = @"女";
    self.gendertype = @"0";

}
//确定按钮
-(void)btnClicked1:(UIButton *)btn {
    
    
    [self.TF resignFirstResponder];
    //self.genderL.text = @"女";
    
    [_cancelBtn removeFromSuperview];
    [_confirmBtn removeFromSuperview];
    [_timePicker removeFromSuperview];
    [_mBtn removeFromSuperview];
    [_gBtn removeFromSuperview];
    [_customView removeFromSuperview];
    [_view1 removeFromSuperview];
    [_line1 removeFromSuperview];
    [_line2 removeFromSuperview];
    //更改生日为时间选择器选择的日期
    
        NSDate * date = self.timePicker.date;
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString * dateString = [dateFormatter stringFromDate:date];


    
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
   
//    NSLog(@"%@",self.genderStr);
//    NSLog(@"%@",dateString);
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    if (dateString != nil) {
        [param setObject:dateString forKey:@"birthday"];
    }else {
        
        [param setObject:@"" forKey:@"birthday"];
        
    }
    
    if (self.gendertype != nil) {
        
//        NSLog(@"%@",self.gendertype);
        
        [param setObject:self.gendertype forKey:@"sex"];

    }else {
        
        
        [param setObject:@"" forKey:@"sex"];
        
    }
//    [param setObject:@"1991-11-11" forKey:@"brithday"];
//    [param setObject:@"0" forKey:@"sex"];
   
    [MKNetworking MKSeniorPostApi:@"/user/sexAndBirthday/update" paramters:param completion:^(MKHttpResponse *response) {
        [ hud hide:YES];
        if (response.errorMsg != nil)
        {
            
            [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
            return ;
        }

//        NSLog(@"%@",[response mkResponseData]);
        
        //更改生日为时间选择器选择的日期
        if (dateString != nil) {
            
            self.birthdayL.text = dateString;
        }
        if (self.genderStr != nil) {
//            NSLog(@"%@",self.genderStr);
            
            //更改性别
            
            self.genderL.text = self.genderStr;

        }
        
    }];
    
    
//     self.genderStr = @"女";
//     self.gendertype = @"0";

}
//选择性别为男
-(void)mBtnClicked:(UIButton *)btn {
    [_mBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _mBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _mBtn.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    [_gBtn setTitleColor:[UIColor colorWithHex:0x888888] forState:UIControlStateNormal];
    _gBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _gBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    self.genderStr = @"男";
    self.gendertype = @"1";
}
//选择性别为女
-(void)gBtnClicked:(UIButton *)btn {
    [_mBtn setTitleColor:[UIColor colorWithHex:0x888888] forState:UIControlStateNormal];
     _mBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
     _mBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [_gBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     _gBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
     _gBtn.titleLabel.font = [UIFont systemFontOfSize:20.0f];
     self.genderStr = @"女";
     self.gendertype = @"0";
}



//图片上传
- (void)uploadImageData:(NSData *)data{
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:UIAppWindow wait:YES];
    
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:@"scl16iPO2OUD1goj" secretKey:@"1J9wWa1ZSVzZ6pSFZ6nTGVhT8BvjG9"];
    
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    
    // 网络请求遇到异常失败后的重试次数
    conf.maxRetryCount = 3;
    
    // 网络请求的超时时间
    conf.timeoutIntervalForRequest =30;
    
    // 允许资源传输的最长时间
    conf.timeoutIntervalForResource =24 * 60 * 60;
    
    // 你的阿里地址前面通常是这种格式 ：http://oss……
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:@"oss-cn-hangzhou.aliyuncs.com" credentialProvider:credential];
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"member/ios_head%@.png", str];
    
    put.bucketName =@"haiynoss";
    put.objectKey = fileName;
    
    put.uploadingData = data; // 直接上传NSData
    
    put.uploadProgress = ^(int64_t bytesSent,int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    
    OSSTask * putTask = [client putObject:put];
    
    // 上传阿里云
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            
            
            [param setObject:[NSString stringWithFormat:@"http://haiynoss.oss-cn-hangzhou.aliyuncs.com/%@",fileName] forKey:@"headImg"];
            
            [MKNetworking MKSeniorPostApi:@"/user/headImg/update" paramters:param completion:^(MKHttpResponse *response) {
                [ hud hide:YES];
                if (response.errorMsg != nil)
                {
                    
                    [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
                    return ;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:MKUserInfoLoadSuccessNotification object:nil];
                });
                NSLog(@"%@",[response mkResponseData]);
                [self.personIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://haiynoss.oss-cn-hangzhou.aliyuncs.com/%@",fileName]]];
                
            }];
        } else {
            [ hud hide:YES];
            [MBProgressHUD showMessageIsWait:@"上传失败！" wait:YES];
        }
        return nil;
    }];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    //[picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:^{
      
        
        
        
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-账户安全逻辑处理
-(void)showSafeViewInfoType:(NSInteger)type
{
   
        switch (type)
        {
            case 0://绑定手机号码
            {
                YLSafeBandViewController *pVc = [[YLSafeBandViewController alloc] init];
                if ( _pSafeInfo && _pSafeInfo.mobile )
                {
                    pVc.nsPhoneNum = _pSafeInfo.mobile;
                    pVc.nsPhoneType = 1;
                    pVc.nsIsCard = ![self isAuthIdCardRealler];
                }
                else
                {
                    pVc.nsPhoneNum = nil;
                    pVc.nsPhoneType = 0;
                    pVc.nsIsCard = YES;
                }
                [self.navigationController pushViewController:pVc animated:YES];
            }
                break;
            case 1://设置密码
            {
                if ( ![self isBandPhoneNum] )
                {
                    [self notBandPhoneNum];
                    return;
                }
                YLSafeLoginPasswordViewController *pVc = [[YLSafeLoginPasswordViewController alloc] init];
                if ( _pSafeInfo && ISNSStringValid(_pSafeInfo.password) && ISNSStringValid(_pSafeInfo.mobile))
                {
                    pVc.nsPhoneNum = _pSafeInfo.mobile;
                    pVc.nsIsChange = YES;
                }else
                {
                    pVc.nsPhoneNum = _pSafeInfo.mobile;
                    pVc.nsIsChange = NO;
                    
                }
                [self.navigationController pushViewController:pVc animated:YES];
            }
                break;
            case 2://支付密码
            {
                if ( ![self isBandPhoneNum] )
                {
                    [self notBandPhoneNum];
                    return;
                }
                if ( ![self isSeller] )
                {
                    [self notSetSeller:@"只有嗨客才能设置支付密码"];
                    return;
                }
                if ( ![self isAuthIdCardRealler] )
                {
                    [self notAuthIdCardRealler];
                    return;
                }
                if ( [self isAuthIdCardRealler]  )
                {
                    YLSafePayPasswordController *pVc = [[YLSafePayPasswordController alloc] init];
                    if ( _pSafeInfo && ISNSStringValid(_pSafeInfo.payPassword) )
                    {
                        pVc.payState = SafePayPasswordStateOld;
                    }else
                    {
                        pVc.payState = SafePayPasswordStateFirstSet;
                    }
                    [self.navigationController pushViewController:pVc animated:YES];
                    
                }
                else
                {
                    [self notAuthIdCardRealler];
                }
            }
                break;
            case 3:
            {
                if ( ![self isBandPhoneNum] )
                {
                    [self notBandPhoneNum];
                    return;
                }
                if ( ![self isSeller] )
                {
                    [self notSetSeller:@"只有嗨客才能进行实名认证"];
                    return;
                }
                if ( [self isAuthIdCardRealler]  )
                {
                    YLSafeAlreadyCardController *pVc = [[YLSafeAlreadyCardController alloc] init];
                    pVc.name = _pSafeInfo.authName;
                    pVc.cardId = _pSafeInfo.authIdCard;
                    [self.navigationController pushViewController:pVc animated:YES];
                }else
                {
                    YLSafeBandCardViewController *pVc = [[YLSafeBandCardViewController alloc] init];
                    if ( [_pSafeInfo.authonStatus integerValue] == -1 ) {
                        pVc.types = 1;
                    }
                    [self.navigationController pushViewController:pVc animated:YES];
                }
            }
                break;
            default:
                break;
        }
}

#pragma mark -判断是否绑定手机
-(BOOL)isBandPhoneNum
{
    if ( _pSafeInfo && ISNSStringValid(_pSafeInfo.mobile) )
    {
        return YES;
    }
    return NO;
}
#pragma mark -判断是否是卖家
-(BOOL)isSeller
{
    if ( _pSafeInfo
        && [_pSafeInfo.roleMark integerValue] == 2 )
    {
        return YES;
    }
    return NO;
}
#pragma mark -判断是否实名认证认证
-(BOOL)isAuthIdCardRealler
{
    if ( _pSafeInfo && [_pSafeInfo.authonStatus integerValue] == 1
        && ISNSStringValid(_pSafeInfo.authIdCard)
        && ISNSStringValid(_pSafeInfo.authName)  )
    {
        return YES;
    }
    return NO;
}
#pragma mark -未实名认证
-(void)notAuthIdCardRealler
{
    __weak typeof(self) weakSelf = self;
    [UIAlertView showWithTitle:@"提示"
                       message:@"未实名认证，是否去实名认证？"
             cancelButtonTitle:@"取消"
             otherButtonTitles:@[@"确定"]
                      tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                          if ( buttonIndex == 1  )
                          {
                              YLSafeBandCardViewController *pVc = [[YLSafeBandCardViewController alloc] init];
                              [weakSelf.navigationController pushViewController:pVc animated:YES];
                          }
                          
                      }];
}

#pragma mark -未绑定手机号码
-(void)notBandPhoneNum
{
    __weak typeof(self) weakSelf = self;
    [UIAlertView showWithTitle:@"提示"
                       message:@"未绑定手机号码，是否去绑定手机号码？"
             cancelButtonTitle:@"取消"
             otherButtonTitles:@[@"确定"]
                      tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                          if ( buttonIndex == 1  )
                          {
                              YLSafeBandViewController *pVc = [[YLSafeBandViewController alloc] init];
                              pVc.nsPhoneNum = nil;
                              pVc.nsIsCard = YES;
                              pVc.nsPhoneType = 0;
                              [weakSelf.navigationController pushViewController:pVc animated:YES];
                          }
                          
                      }];
}
#pragma mark -未开店铺
-(void)notSetSeller:(NSString *)message
{
    [UIAlertView showWithTitle:@"提示"
                       message:message
             cancelButtonTitle:@"确定"
             otherButtonTitles:nil
                      tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                          
                      }];
    
}
#pragma mark -网络请求
-(void)OnRequest
{
    __weak typeof(self) weakSelf = self;
    [YLSafeTool sendUserSafeInfoQuerySuccess:^(id nMsg)
     {
         [weakSelf sentSafeView:nMsg];
     } failure:^{
         
     }];
}

#pragma mark -账户安全更新数据
-(void)sentSafeView:(YLSafeUserInfo *)userInfo
{
    _pSafeInfo = userInfo;
    if ( userInfo && ISNSStringValid(userInfo.mobile) )
    {
        self.phoneRight.text =@"修改";
    }else
    {
        self.phoneRight.text =@"设置";
    }
    if ( userInfo &&  ISNSStringValid(userInfo.password) )
    {
        self.lgoinRight.text =@"修改";

    }else
    {
        self.lgoinRight.text =@"设置";
    }
    if ( userInfo &&  ISNSStringValid(userInfo.payPassword) )
    {
        self.payRight.text =@"修改";
    }else
    {
        self.payRight.text =@"设置";
    }
    if ( userInfo &&  ISNSStringValid(userInfo.authIdCard) && [_pSafeInfo.authonStatus integerValue] == 1 )
    {
        self.cardRight.text =@"已认证";
        self.cardRight.textColor = kHEXCOLOR(0x05be03);
        
    }
    else if ( userInfo &&  ISNSStringValid(userInfo.authIdCard) && [_pSafeInfo.authonStatus integerValue] == 0 )
    {
        self.cardRight.text =@"审核中";
        self.cardRight.textColor = kHEXCOLOR(0x05be03);
        
    }
    else if ( userInfo &&  ISNSStringValid(userInfo.authIdCard) && [_pSafeInfo.authonStatus integerValue] == 2 )
    {
        self.cardRight.text =@"认证失败";
        self.cardRight.textColor = kHEXCOLOR(kRedColor);
        
    }
    else
    {
        self.cardRight.text =@"未认证";
        self.cardRight.textColor = kHEXCOLOR(kRedColor);
    }
    
}

@end
