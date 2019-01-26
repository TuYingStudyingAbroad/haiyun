//
//  MKAfterSalesViewController.m
//  嗨云项目
//
//  Created by 杨鑫 on 16/5/14.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKAfterSalesViewController.h"
#import <PureLayout.h>
#import "AppDelegate.h"
#import "MKBackView.h"
#import "UIView+MKExtension.h"
#import "MKNetworking+BusinessExtension.h"
#import "MBProgressHUD+MKExtension.h"
#import "NSArray+MKExtension.h"
#import "MKReturnViewController.h"

@interface MKAfterSalesViewController ()<UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@property (weak, nonatomic) IBOutlet UILabel *originaLabel;
@property (weak, nonatomic) IBOutlet UITextView *originallyTextF;
@property (weak, nonatomic) IBOutlet UILabel *shuoMingLabel;
@property (weak, nonatomic) IBOutlet UILabel *baiFenBI;

@property (nonatomic,strong)UIView *backView;

@property (nonatomic,strong)UITextField *textField;


@property (nonatomic,strong)MKBackView * mkBackView;


@property (nonatomic,strong)NSMutableArray *dataSouce;
@property (nonatomic,strong)NSMutableArray *dataSouceID;


@property (nonatomic,strong)NSString *refundReasonId;

@end

@implementation MKAfterSalesViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSouce = [NSMutableArray array];
    self.dataSouceID = [NSMutableArray array];
    // Do any additional setup after loading the view.
    UIBarButtonItem *but = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:(UIBarButtonItemStyleDone) target:self action:@selector(handleSubmitAction:)];
    self.navigationItem.rightBarButtonItem = but;
    self.originallyTextF.delegate = self;
    self.shuoMingLabel.userInteractionEnabled = YES;
    self.backView = [[UIView alloc]init];
   self.textField = [[UITextField alloc]init];
    [self.backView addSubview:_textField];
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.alpha = 0.2f;
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button addTarget:self action:@selector(handleRemoveAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.backView addSubview:button];
    [button autoPinEdgesToSuperviewEdgesWithInsets:(UIEdgeInsetsZero)];
    [self loadBackView];
}
- (void)handleRemoveAction{
    [self.backView removeFromSuperview];
    [self.textField resignFirstResponder];
    
}
- (void)loadBackView{
    self.mkBackView = [MKBackView loadFromXib];
    [self.mkBackView autoSetDimension:(ALDimensionHeight) toSize:180];
    self.textField.inputView = self.mkBackView;
    self.textField.inputAccessoryView = [[UIView alloc]init];
    [self.mkBackView.remoBut addTarget:self action:@selector(handleRemoveAction) forControlEvents:(UIControlEventTouchUpInside)];
}
- (void)handleSubmitAction:(id)sender{
    if (!self.refundReasonId) {
        [MBProgressHUD showMessageIsWait:@"请选择售后原因" wait:YES];
        return;
    }
    MBProgressHUD *hub  = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.refundReasonId forKey:@"refund_reason_id"];
//    [dict setObject: forKey:@"refund_amount"];
//    [dict setObject: forKey:@"refund_desc"];
//    [dict setObject: forKey:@"sku_uid"];
    NSArray *ar = [NSArray arrayWithObject:dict];
    [MKNetworking MKSeniorPostApi:@"trade/refund/apply" paramters:@{@"refund_list":[ar jsonString],@"order_uid":self.object.orderUid,@"user_id":@(getUserCenter.userInfo.userId)} completion:^(MKHttpResponse *response) {
        
        if (response.errorMsg) {
            [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
            [hub hide:YES];
            return ;
        }
        if ([response.responseDictionary[@"code"] isEqualToNumber: @(10000)]) {
            NSMutableArray *viewCou = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [viewCou removeLastObject];
            self.navigationController.viewControllers = viewCou;
            MKReturnViewController *re = [MKReturnViewController create];
            re.object = self.object;
            [self.navigationController pushViewController:re animated:YES];
            [hub hide:YES];
        }
    }];
    
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.text.length > 200) {
        return NO;
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)handleWhy:(id)sender {
    
    [MKNetworking MKSeniorGetApi:@"trade/refund/reason/list" paramters:nil completion:^(MKHttpResponse *response) {
        
        if (response.errorMsg) {
            [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
            return ;
        }
        NSArray *array = [response responseDictionary][@"data"][@"refund_reason_list"];
        for (NSDictionary *dic in array) {
            [self.dataSouce addObject:dic[@"refund_reason"]];
            [self.dataSouceID addObject:dic[@"refund_reason_id"]];
        }
        [self.originallyTextF resignFirstResponder];
        [appDelegate.window addSubview:self.backView];
        [self.backView autoPinEdgesToSuperviewEdgesWithInsets:(UIEdgeInsetsZero)];
        [self.textField becomeFirstResponder];
        self.mkBackView.mkBackPicker.dataSource = self;
        self.mkBackView.mkBackPicker.delegate = self;
    }];
    
    
    
    
    
}
- (void)textViewDidChange:(UITextView *)textView {
    if (self.originallyTextF.text.length) {
        self.shuoMingLabel.hidden = YES;
    }else{
        self.shuoMingLabel.hidden = NO;
    }
    self.baiFenBI.text = [NSString stringWithFormat:@"%ld/200",(unsigned long)self.originallyTextF.text.length];
//    NSLog(@"textViewDidChange：%@", textView.text);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.dataSouce count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.dataSouce objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self.originaLabel setText:self.dataSouce[row]];
    self.refundReasonId = self.dataSouceID[row];
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
