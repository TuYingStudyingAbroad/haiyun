//
//  UIApplication+MKBaseLib.m
//  MKBaseLib
//
//  Created by cocoa on 15/4/21.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "UIApplication+MKBaseLib.h"

@implementation UIApplication (MKBaseLib)

- (void)baseLib_toggleNetworkActivityIndicatorVisible:(BOOL)visible
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
