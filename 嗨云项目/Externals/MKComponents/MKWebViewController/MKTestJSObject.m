//
//  MKTestJSObject.m
//  YangDongXi
//
//  Created by 李景 on 16/3/16.
//  Copyright © 2016年 yangdongxi. All rights reserved.
//

#import "MKTestJSObject.h"
#import "HYShareInfo.h"
#import "HYShareKit.h"
#import "AppDelegate.h"
#import "MBProgressHUD+MKExtension.h"
#import "UIView+MKExtension.h"
#import "MKBaseLib.h"


@interface MKTestJSObject ()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,strong)UIActionSheet *sheet;

@property (nonatomic,strong)UIView *backView;



@end

@implementation MKTestJSObject

- (UIView *)backView{
    if (!_backView) {
        self.backView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
        _backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
    }
    return _backView;
}
- (void)call:(id)JSText{
    NSString *str = [NSString stringWithFormat:@"%@",JSText];
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    if ([JSText isKindOfClass:[NSDictionary class]]) {
        self.dic = JSText;
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers              error:&err];
        self.dic = dic;
    }
    
    if ([[NSString stringWithFormat:@"%@",self.dic[@"cmd"]] isEqualToString: @"2"]) {
        [self showSheet];
    }
    if ([[NSString stringWithFormat:@"%@",_dic[@"cmd"]] isEqualToString: @"1"]) {
        self.returnTextBlock(self.dic);
    }
    if ([[NSString stringWithFormat:@"%@",self.dic[@"cmd"]] isEqualToString: @"3"]) {
        self.returnTextBlock(self.dic);
    }
    self.returnTextBlock(self.dic);
    
//    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:self.dic,@"chuanzhi",nil];
//    
//    //创建通知
//    
//    NSNotification *notification =[NSNotification notificationWithName:@"laqizhifu" object:nil userInfo:dict];
//    
//    //通过通知中心发送通知
//    
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
}


- (void)returnText:(returnBlock)block
{
    self.returnTextBlock = block;
}


- (void)showSheet{
    _sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消"
                           destructiveButtonTitle:@"拍照"
                                otherButtonTitles:@"从相册处选择",nil];
    dispatch_async(dispatch_get_main_queue(), ^{
       [_sheet showInView:[UIApplication sharedApplication].keyWindow];
    });
    
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    self.isRef = YES;
    switch (buttonIndex)
    
    {
            case 0:  //打开照相机拍照
            [self takePhoto];
            break;
        case 1:  //打开本地相册
            [self LocalPhoto];
            break;
    }
}
- (void)takePhoto{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [[UIApplication sharedApplication].keyWindow.rootViewController  presentViewController: picker animated: YES completion:nil];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}
- (void)LocalPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [[UIApplication sharedApplication].keyWindow.rootViewController  presentViewController: picker animated: YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
        
        
        
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        // 设置时间格式
        MKMulipartFormObject * object = [[MKMulipartFormObject alloc]init];
        //    [object addJPGData:data withName:@"images"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        [object addFileData:data withName:@"images" type:@"image/png" filename:fileName];
        [object addParameters:@{@"media_auth_key":@"6r4XkF6EcE"}];
        [MKNetworking POST:@"http://b.taojae.com/service.php" form:object completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
            NSLog(@"%@",responseObject);
            if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString: @"10000"]){
                NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString: @"10000"]){
                    NSString *strUrl = responseObject[@"data"][@"url"];
                    self.returnStrUrl(strUrl,self.dic);
                }else{
                    [MBProgressHUD showMessageIsWait:@"上传失败，请重新上传" wait:YES];
                }
            }
        }];
//        self.waitView = [BlackWaitView loadFromXib];
//        [self show:@"正在上传" with:YES];
//        [[AFHTTPRequestOperationManager manager] POST:@"http://b.taojae.com/service.php" parameters:@{@"media_auth_key":@"6r4XkF6EcE"} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//            [formData appendPartWithFileData:data name:@"images" fileName:fileName mimeType:@"image/png"];
//        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
////            [self show:@"上传成功" with:NO];
//            if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString: @"10000"]){
//                NSString *strUrl = responseObject[@"data"][@"url"];
//                self.returnStrUrl(strUrl,self.dic);
//            }else{
//                [MBProgressHUD showMessageIsWait:@"上传失败，请重新上传" wait:YES];
//            }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                [MBProgressHUD showMessageIsWait:@"上传失败，请重新上传" wait:YES];
//        }];
//                //关闭相册界面
//        [picker dismissViewControllerAnimated:YES completion:^{
//            self.isRef = YES;
//        }];
    }
}


@end
