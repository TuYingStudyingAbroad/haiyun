//
//  UIApplication+MKExtension.m
//  MKBaseLib
//
//  Created by cocoa on 15/2/5.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "UIApplication+MKExtension.h"

@implementation UIApplication (MKExtension)

- (void)toggleNetworkActivityIndicatorVisible:(BOOL)visible
{
    if ([self isStatusBarHidden]) return;
    
    static int activityCount = 0;
    @synchronized (self)
    {
        visible ? activityCount++ : activityCount--;
        self.networkActivityIndicatorVisible = activityCount > 0;
        if (activityCount < 0)
        {
            activityCount = 0;
        }
    }
}

@end
