//
//  MKVouchersViewController.m
//  YangDongXi
//
//  Created by windy on 15/5/6.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKVouchersViewController.h"
#import "UIColor+MKExtension.h"
#import "MKTextField.h"

@interface MKVouchersViewController ()

@property (nonatomic,weak) IBOutlet MKTextField *textField;
@property (nonatomic,weak) IBOutlet UIButton *activationBtn;

@end

@implementation MKVouchersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"代金券";
    // Do any additional setup after loading the view.
    self.activationBtn.layer.borderColor = [UIColor colorWithHex:0xff4b55].CGColor;
    self.activationBtn.layer.cornerRadius = 12;
    self.activationBtn.layer.borderWidth = 1;
    
    self.textField.layer.cornerRadius = 3.0f;
    self.textField.layer.masksToBounds= YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//激活代金券
- (IBAction)clickActivationBtn:(id)sender
{
    
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
