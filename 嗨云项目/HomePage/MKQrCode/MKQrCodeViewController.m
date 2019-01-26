//
//  MKQrCodeViewController.m
//  YangDongXi
//
//  Created by windy on 15/4/22.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKQrCodeViewController.h"
#import "MKQrCodeModel.h"
#import "MKSmartExPressViewController.h"
#import "MKCommonTextViewViewController.h"
#import "MBProgressHUD+MKExtension.h"
#import "UIViewController+MKExtension.h"
#import "MKBaseLib.h"
#import "MKUrlGuide.h"
#import "UIImage+Resizing.h"

@interface MKQrCodeViewController ()
<UINavigationControllerDelegate, UIImagePickerControllerDelegate, MKQrCodeModelDelegate, UIAlertViewDelegate>
{
    SystemSoundID  soundID;
}

@property (strong, nonatomic) IBOutlet UIImageView *topBackImageView;
@property (strong, nonatomic) IBOutlet UIImageView *leftBackImageView;

@property (strong, nonatomic) IBOutlet UIImageView *rightBackImageView;
@property (strong, nonatomic) IBOutlet UIImageView *bottomBackImageView;
@property (strong, nonatomic) IBOutlet UIButton *photoButton;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) IBOutlet UIView *secondView;

@property (nonatomic, strong) UIImageView *line;

@property (nonatomic, weak) IBOutlet UIView *scanRectView;

@property (nonatomic, strong) MKQrCodeModel *qrCodeModel;

@property (nonatomic, strong) MBProgressHUD *progressHUD;

@property (nonatomic, assign) BOOL stop;


@end


@implementation MKQrCodeViewController

- (void)dealloc
{
    AudioServicesDisposeSystemSoundID(soundID);
    [self.qrCodeModel stop];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"扫码锦囊" style:UIBarButtonItemStylePlain
//                                                                          target:self action:@selector(scanHelp:)];
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.buttonView.layer.cornerRadius = 20;
    self.buttonView.layer.masksToBounds = YES;
    
    self.qrCodeModel = [[MKQrCodeModel alloc] init];
    self.qrCodeModel.delegate = self;
    [self.qrCodeModel initializeDevice];
    [self.view.layer insertSublayer:self.qrCodeModel.previewLayer atIndex:0];
    self.stop = YES;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"scan" ofType:@"mp3"];
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

    [self.qrCodeModel start];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.qrCodeModel stop];
    self.stop = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.stop = NO;
    //相机权限
}

- (void)viewDidLayoutSubviews
{
    self.qrCodeModel.previewLayer.frame = self.view.bounds;
    [self animationScanLine];
    [super viewDidLayoutSubviews];
}

//扫描线动画
- (void)animationScanLine
{
    static CGRect bounds;
    if (CGRectEqualToRect(bounds, self.view.bounds) && self.line != nil)
    {
        return;
    }
    bounds = self.view.bounds;
    [self.line removeFromSuperview];
    
    UIImage *lineImage = [UIImage imageNamed:@"scan_line.png"];
    lineImage = [lineImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, lineImage.size.width / 2, 0, lineImage.size.width / 2)];
    self.line = [[UIImageView alloc] initWithImage:lineImage];
    self.line.frame = CGRectMake(6, 0, self.scanRectView.frame.size.width - 12, lineImage.size.height);
    [self.scanRectView addSubview:self.line];
    
    CABasicAnimation *rotation;
    rotation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    rotation.toValue = [NSNumber numberWithFloat:self.scanRectView.frame.size.height - 10];
    rotation.duration = 2;
    rotation.repeatCount = NSIntegerMax;
    rotation.removedOnCompletion = NO;
    [self.line.layer addAnimation:rotation forKey:@"rotationAnimation"];
}
//
////扫描锦囊按钮
//- (void)scanHelp:(id)sender
//{
//    MKSmartExPressViewController *vc = [MKSmartExPressViewController create];
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)decodeFailed:(NSString *)msg
{
    if (msg == nil)
    {
        msg = @"哎呀~眼睛看花了";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil
                                              cancelButtonTitle:@"再试一次" otherButtonTitles:nil, nil];
    alertView.delegate = self;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.qrCodeModel continueCapture];
}

#pragma mark - pickerDelegate Methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *localImage = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
    
    [picker dismissViewControllerAnimated:YES completion:^
     {
         if (localImage == nil)
         {
             [self decodeFailed:nil];
             return;
         }
         CGFloat width = 600;
         CGFloat height = 800;
         if (localImage.size.width > localImage.size.height)
         {
             width = 800;
             height = 600;
         }
         UIImage *image = localImage;
         if (localImage.size.width > width && localImage.size.height > height)
         {
             image = [image scaleToFitSize:CGSizeMake(width, height)];
         }
         [self.progressHUD hide:YES];
         self.progressHUD = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
         [self.qrCodeModel decodeImageAsynchronously:image];
     }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^
     {
         [self.qrCodeModel continueCapture];
     }];
}

- (void)qrCodeModel:(MKQrCodeModel *)model capturedText:(NSString *)text
{
    AudioServicesPlaySystemSound(soundID);
    [self.progressHUD hide:YES];
    self.progressHUD = nil;
    if (self.stop)
    {
        return;
    }
    if (text.length == 0)
    {
        [self decodeFailed:nil];
        return;
    }
    [self.qrCodeModel pauseCapture];
    [self parseText:text];
}

- (void)qrCodeModel:(MKQrCodeModel *)model deviceError:(NSError *)error
{
    NSString *msg = error.localizedFailureReason;
    if (error.code == -11852)
    {
        msg = @"请在iPhone的“设置-隐私-相机”选项中，允许洋东西商城访问您的相机。";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil
                                              cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - ZXCaptureDelegate Methods

- (void)parseText:(NSString *)text
{
    if ([[MKUrlGuide commonGuide] canHandle:text])
    {
        [[MKUrlGuide commonGuide] guideForUrl:text];
    }
    else
    {
        [self showNormalTextViewController:text];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        [self.qrCodeModel continueCapture];
    });
}

- (void)showNormalTextViewController:(NSString *)text
{
    MKCommonTextViewViewController *ctv = [[MKCommonTextViewViewController alloc] init];
    ctv.text = text;
    [self.navigationController pushViewController:ctv animated:YES];
}

- (IBAction)localPhotoButton:(id)sender
{
    [self.qrCodeModel pauseCapture];
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}


@end
