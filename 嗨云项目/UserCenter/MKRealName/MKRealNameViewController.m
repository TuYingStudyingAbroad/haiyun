//
//  MKRealNameViewController.m
//  YangDongXi
//
//  Created by windy on 15/5/7.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKRealNameViewController.h"
#import "MBProgressHUD+MKExtension.h"
#import "UIImage+Resizing.h"
#import "MKNetworking+BusinessExtension.h"
#import "MKRealNameObject.h"
#import "NSDictionary+MKExtension.h"

@interface MKRealNameViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate>

@property (nonatomic,weak) IBOutlet UIButton *frontBtn;

@property (nonatomic,weak) IBOutlet UIButton *reverseBtn;

@property (nonatomic,assign) NSInteger currentSelectingImage;
@property (nonatomic,strong) UIImage *selectedFrontImage;
@property (nonatomic,strong) UIImage *selectedBackImage;

@property (nonatomic,weak) IBOutlet UIImageView *frontImagView;
@property (nonatomic,weak) IBOutlet UIImageView *reverseImagView;
@property (nonatomic,weak) IBOutlet UILabel *frontLabel;
@property (nonatomic,weak) IBOutlet UILabel *resverseLabel;

@property (nonatomic,weak) IBOutlet UITextField *nameTextField;
@property (nonatomic,weak) IBOutlet UITextField *idTextField;

@end

@implementation MKRealNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";

    // Do any additional setup after loading the view.
    self.frontBtn.clipsToBounds = YES;
    self.frontBtn.layer.cornerRadius= 3;
    
    self.reverseBtn.clipsToBounds = YES;
    self.reverseBtn.layer.cornerRadius= 3;
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completeBtnClick:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    [self getAuthInfo];
}

- (void)getAuthInfo
{
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    
    [MKNetworking MKSeniorGetApi:@"/user/auth/get" paramters:nil completion:^(MKHttpResponse *response)
     {
         [ hud hide:YES];
         if (response.errorMsg != nil)
         {
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             return ;
         }
         NSDictionary *dict = [response mkResponseData][@"auth_info"];
         if (dict)
         {
             self.nameTextField.text = [dict objectForKey:@"real_name"];
             self.idTextField.text = [dict objectForKey:@"idcard_no"];
         }
         
     }];
    
}

- (IBAction)clickFrontBtn:(id)sender
{
    self.currentSelectingImage = 0;
    [self showActionSheet];
}

- (IBAction)clickReverseBtn:(id)sender
{
    self.currentSelectingImage = 1;
    [self showActionSheet];

}

#pragma mark
#pragma mark - UIImagePickerController Delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        if (self.currentSelectingImage) {
            UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
            self.selectedBackImage = [image scaleByFactor:0.5];
            self.reverseImagView.hidden = YES;
            self.resverseLabel.hidden = YES;
            [self.reverseBtn setBackgroundImage:self.selectedBackImage forState:UIControlStateNormal];
        }else{
            UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
            self.selectedFrontImage = [image scaleByFactor:0.5];
            self.frontImagView.hidden = YES;
            self.frontLabel.hidden = YES;
//            [self.frontBtn setImage:self.selectedFrontImage forState:UIControlStateNormal];
            [self.frontBtn setBackgroundImage:self.selectedFrontImage forState:UIControlStateNormal];

        }
    }];
}



#pragma mark
#pragma mark - UIAction Sheet
- (void)showActionSheet{
    UIActionSheet *actionSheet;
    if (!actionSheet) {
        actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    }
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    switch (buttonIndex) {
        case 0:{
            if (NSNotFound != [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location) {
                [MBProgressHUD showMessageIsWait:@"你的设备不支持拍摄" wait:YES];
            }else{
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:^{
                    actionSheet.delegate = nil;
                }];
            }
        }
            break;
        case 1:{
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:^{
                actionSheet.delegate = nil;
            }];
        }
            break;
        default:
            break;
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    actionSheet.delegate = nil;
}

- (void)completeBtnClick:(id)sender
{
    NSString *idStr = self.idTextField.text;
    NSString *nameStr = self.nameTextField.text;
    if (nameStr.length == 0)
    {
        [MBProgressHUD showMessageIsWait:@"请输入姓名" wait:YES];
        return;
    }
    if (![self isValidateIdentityCard:idStr])
    {
        [MBProgressHUD showMessageIsWait:@"请正确的身份证号码" wait:YES];
        return;
    }
    MKRealNameObject*realNameItem = [[MKRealNameObject alloc] init];
    realNameItem.realName = nameStr;
    realNameItem.idCard = idStr;
    
    NSString *str = [[realNameItem dictionarySerializer] jsonString];

    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    [MKNetworking MKSeniorPostApi:@"/user/auth/add" paramters:@{@"auth_info" : str} completion:^(MKHttpResponse *response)
     {
         [ hud hide:YES];
         if (response.errorMsg != nil)
         {
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             return ;
         }
         
         [MBProgressHUD showMessageIsWait:@"认证成功" wait:YES];
         
         [self.navigationController popViewControllerAnimated:YES];
     }];
    
}

/**
 *  验证身份证号
 */
- (BOOL)isValidateIdentityCard:(NSString *)identityCard
{
    BOOL flag;
    
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    
    NSString *regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    return [identityCardPredicate evaluateWithObject:identityCard];
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
