//
//  bankEditViewController.m
//  嗨云项目
//
//  Created by kans on 16/5/12.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "bankEditViewController.h"
#import "AppDelegate.h"
#import <PureLayout.h>
#import "MBProgressHUD+MKExtension.h"
#import "MKNetworking+BusinessExtension.h"
#import "PersonalInfo.h"
@interface bankEditViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

{
    NSString * cardName;
    NSMutableDictionary *banksDic;
    //用于标记不滑动pickerView时点击确定显示第一个名字；
    NSInteger macker;
    
}
@property (weak, nonatomic) IBOutlet UITextField *cardNameTF;

@property (weak, nonatomic) IBOutlet UITextField *cardNumTF;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong)UIView *backView;
@property (strong, nonatomic) UIPickerView *locatePicker;
@property (strong,nonatomic)NSArray * arr;
@property (retain , nonatomic) PersonalInfo* personalInfoModel;

@end

@implementation bankEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"添加银行卡";
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain
                                                                       target:self action:@selector(completeBtnClick:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
 
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"bankLogo" ofType:@"plist"];
    banksDic = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    _arr=[banksDic allKeys];
    //单例付名字；
    self.personalInfoModel=[PersonalInfo sharedModel];
    self.nameLab.text=self.personalInfoModel.nameStr;
    
//    [appDelegate.window addSubview:self.textField];
    [self setupPickerView];
    [self showBackView];
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField.tag==100) {
        if (toBeString.length>23 ) {
            textField.text = [toBeString substringToIndex:23];
            return NO;
        }
    }
    return YES;
}

- (IBAction)btn:(id)sender {
    [self showBack];
}

- (void)showBack{
    self.backView = [[UIView alloc]initWithFrame:CGRectZero];
    self.backView.backgroundColor = [UIColor lightGrayColor];
    self.backView.alpha = .8f;
   // [appDelegate.window addSubview:self.backView];
//    
//    [self.backView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [self.cardNameTF becomeFirstResponder];
}
- (void)showBackView{
     self.cardNameTF.delegate=self;
    
    UIView *inputViewUp = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    [inputViewUp setBackgroundColor:[UIColor colorWithHexString:@"f5f5f5"]];
    inputViewUp.alpha=0.5;
    UIButton *but = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [but setTitle:@"确定" forState:(UIControlStateNormal) ];
    [but setTintColor:[UIColor blackColor]];
    [but addTarget:self action:@selector(handleActionGoBack) forControlEvents:(UIControlEventTouchUpInside)];
    [inputViewUp addSubview:but];
    [but autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [but autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    
    UIButton *but1 = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [but1 setTitle:@"取消" forState:(UIControlStateNormal) ];
    [but1 setTintColor:[UIColor blackColor]];
    [but1 addTarget:self action:@selector(handleActionGoBack1) forControlEvents:(UIControlEventTouchUpInside)];
    [inputViewUp addSubview:but1];
    [but1 autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [but1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    
    self.cardNameTF.inputAccessoryView =inputViewUp;
    
    
    UIView *inputViewBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 180)];
    inputViewBack.backgroundColor = [UIColor whiteColor];
    self.cardNameTF.inputView =self.locatePicker;
}
- (void)setupPickerView
{
    self.locatePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
    self.locatePicker.delegate = self;
    self.locatePicker.dataSource = self;
    self.locatePicker.showsSelectionIndicator = YES;
    self.locatePicker.backgroundColor=[UIColor whiteColor];
    [self.locatePicker reloadAllComponents];
    
    //[self reloadPickerView];
}
#pragma mark -------------------- UIPickerViewDelegate,UIPickerViewDataSource --------------------
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _arr.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法根据row参数返回teams中的元素，row参数代表列表项的编号，
    // 因此该方法表示第几个列表项，就使用teams中的第几个元素
    
    return [_arr objectAtIndex:row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{

    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //标记不滑动的时候
       macker=row;
       cardName =[NSString stringWithFormat:@"%@",_arr[row]] ;
}

//确定
-(void)handleActionGoBack{
    if (macker==0) {
        self.cardNameTF.text=_arr[0];
    }else{
    
    self.cardNameTF.text=cardName;
   
    }
    [appDelegate.window endEditing:YES];
    [self.backView removeFromSuperview];
}
-(void)handleActionGoBack1{
    
    [appDelegate.window endEditing:YES];
    [self.backView removeFromSuperview];
}
//完成
- (void)completeBtnClick:(id)sender{
    
    NSString *idStr = self.cardNumTF.text;
    
    NSString *nameStr = self.cardNameTF.text;
    
    
    if (nameStr.length == 0)
    {
        [MBProgressHUD showMessageIsWait:@"请选择发卡银行" wait:YES];
        return;
    }
    if (idStr.length<16&&idStr.length>0)
    {
        [MBProgressHUD showMessageIsWait:@"请输入16-23位银行卡号" wait:YES];
        return;
    }
    if (idStr.length == 0)
    {
        [MBProgressHUD showMessageIsWait:@"请输入银行卡号" wait:YES];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    
    NSMutableDictionary *param =
    [NSMutableDictionary dictionaryWithDictionary:@{@"bank_name" : nameStr,
                                                    @"bank_no" : idStr}];
    
   
    [MKNetworking MKSeniorPostApi:@"/myaccount/bank/save" paramters:param completion:^(MKHttpResponse *response){
         [ hud hide:YES];
        
        if (response.errorMsg != nil)
        {
           
            [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
            return ;
        }
        //判断添加是否正确添加
        if ([[NSString stringWithFormat:@"%@",response.responseDictionary[@"code"]]isEqualToString:@"10000"]) {
             [MBProgressHUD showMessageIsWait:@"添加成功" wait:YES];
            [self.navigationController popViewControllerAnimated:YES];
            [self addBank:param];
            
        }

    }];
    

    //上传数据
    
//
}
-(void)addBank:(NSDictionary *)bankDic{
    
    WXHBankListObject* bankListOBJ=[[WXHBankListObject alloc]init];
    bankListOBJ.bankNO=bankDic[@"bank_no"];
    bankListOBJ.bankName=bankDic[@"bank_name"];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didSuccessAddBank:)]) {
        [self.delegate didSuccessAddBank:bankListOBJ];
    }
}
/**
 *  验证身份证号
 */
//- (BOOL)isValidateIdentityCard:(NSString *)identityCard
//{
//    BOOL flag;
//    
//    if (identityCard.length > 16&&identityCard.length<23) {
//        flag = NO;
//        return flag;
//    }else{
//        return YES;
//    }
//    
////    NSString *regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
////    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
////    
////    return [identityCardPredicate evaluateWithObject:identityCard];
//}
//

@end
