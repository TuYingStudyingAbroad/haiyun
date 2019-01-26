//
//  HYPhoto.m
//  嗨云项目
//
//  Created by haiyun on 16/9/1.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYPhoto.h"
#import <UIAlertView+Blocks.h>

HYPhoto    *g_HYPhoto = NULL;

@implementation HYPhoto

+(HYPhoto *)getSharePhoto
{
    if (g_HYPhoto == NULL)
    {
        g_HYPhoto = NewObject(HYPhoto);
    }
    return g_HYPhoto;
}

-(void)getPhoto:(id)sender
           Back:(BOOL)bBack
          Image:(Image)image
{
    if (sender == NULL)
    {
        return;
    }
    
    self.sender = sender;
    _bBack = bBack;
    self.imageblock = image;
    
    HYActionSheetViewController * actionSheet = [[HYActionSheetViewController alloc] init];
    actionSheet.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    actionSheet.delegate = g_HYPhoto;
    [getMainTabBar.selectedNav presentViewController:actionSheet animated:NO completion:nil];
    

}

-(void)getCamera:(id)sender
            Back:(BOOL)bBack
           Image:(Image)image
{
    if (sender == NULL)
    {
        return;
    }
    
    self.sender  = sender;
    _bBack = bBack;
    self.imageblock = image;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [self displayImagePickerWithSource:UIImagePickerControllerSourceTypeCamera];
    }
    else
    {
        NSLog(@"该设备不支持此功能！");
    }
}

-(void)getPicture:(id)sender
            Image:(Image)image
{
    if (sender == NULL)
    {
        return;
    }
    self.sender = sender;
    self.imageblock = image;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        [self displayImagePickerWithSource:UIImagePickerControllerSourceTypePhotoLibrary];
    }else
    {
        NSLog(@"该设备不支持此功能！");
    }
}

-(void)displayImagePickerWithSource:(UIImagePickerControllerSourceType)src;
{
    if ( src == UIImagePickerControllerSourceTypeCamera )
    {
        if (_bBack && ![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear])
        {
            NSLog(@"此设备不支持后置摄像头！");
            return;
        }
        
        if (!_bBack && ![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
        {
            NSLog(@"此设备不支持前置摄像头！");
            return;
        }
        AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
        {
            [UIAlertView showWithTitle:@""
                               message:@"请在iPhone的“设置－隐私－相机”选项中，允许嗨云访问的相机。"
                     cancelButtonTitle:@"确定"
                     otherButtonTitles:nil
                              tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                                  
                              }];
        }
    }
    if([UIImagePickerController isSourceTypeAvailable:src])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setDelegate:g_HYPhoto];
        picker.sourceType = src;
        picker.modalPresentationStyle = UIModalPresentationCurrentContext;
        picker.allowsEditing = YES;
        if (src == UIImagePickerControllerSourceTypeCamera)
        {
            picker.showsCameraControls = YES;
        }
        
        [getMainTabBar.selectedNav.topViewController presentViewController:picker animated:YES completion:nil];
        
        picker = nil;
    }
}
#pragma mark -HYActionSheetViewControllerDelegate
- (void)actionSheetView:(HYActionSheetViewController *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 2://拍照
        {
            [self displayImagePickerWithSource:UIImagePickerControllerSourceTypeCamera];
        }
            break;
        case 1://从相册获取
        {
            [self displayImagePickerWithSource:UIImagePickerControllerSourceTypePhotoLibrary];
        }
            break;
        default:
            break;
    }
}
#pragma mark -UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    picker = nil;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)imagePickerController:(UIImagePickerController *)pickerImage didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* photoimage = [info objectForKey:UIImagePickerControllerEditedImage];
        [pickerImage dismissViewControllerAnimated:YES completion:^{
            
            //
            [self OnEditImage:photoimage];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
    }
}


#pragma mark -处理照片
- (void)OnEditImage:(UIImage *)photoImage
{
    if( self.imageblock )
    {
        self.imageblock(photoImage,self.sender);
    }
}


@end
