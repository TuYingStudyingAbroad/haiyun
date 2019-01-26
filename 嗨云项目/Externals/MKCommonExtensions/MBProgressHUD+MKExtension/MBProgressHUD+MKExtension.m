//
//  MBProgressHUD+MKExtension.m
//  YangDongXi
//
//  Created by cocoa on 15/4/14.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MBProgressHUD+MKExtension.h"

@implementation MBProgressHUD (MKExtension)

+ (MBProgressHUD *)showMessage:(NSString *)msg wait:(BOOL)wait;
{
    return [self showMessage:msg inView:[[UIApplication sharedApplication] keyWindow] wait:wait];
}
+ (MBProgressHUD *)showMessageIsWait:(NSString *)msg wait:(BOOL)wait{
    return [self showMessagea:msg inView:[[UIApplication sharedApplication] keyWindow] wait:wait];
}
+ (MBProgressHUD *)showMessage:(NSString *)msg inView:(UIView *)view wait:(BOOL)wait
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.userInteractionEnabled = wait;
    hud.removeFromSuperViewOnHide = YES;
    hud.detailsLabelText = msg;
    if (!wait)
    {
        hud.mode = MBProgressHUDModeText;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                       {
                           [hud hide:YES];
                       });
    }
    [hud show:YES];
    return hud;
}
+ (MBProgressHUD *)showMessagea:(NSString *)msg inView:(UIView *)view wait:(BOOL)wait
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.userInteractionEnabled = wait;
    hud.removeFromSuperViewOnHide = YES;
    hud.detailsLabelText = msg;
    if (wait)
    {
        hud.mode = MBProgressHUDModeCustomView;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                       {
                           [hud hide:YES];
                       });
    }
    
    [hud show:YES];
    return hud;
}


@end
