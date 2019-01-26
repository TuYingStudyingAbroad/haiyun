//
//  HYBaseScrollView.h
//  HaiYun
//
//  Created by YanLu on 16/4/21.
//  Copyright © 2016年 YanLu. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "HYBaseView.h"

@interface HYBaseScrollView : UIScrollView
{
    HYBaseView * _pBaseView;
    BOOL _bShowLoading;//界面是否显示加载
    BOOL _bEndLoading;//加载停止判断
}

@property (nonatomic,strong) HYBaseView* pBaseView;
@property (nonatomic, weak) __weak id<HYBaseViewDelegate> baseDelegate;

@property BOOL bShowLoading;
@property BOOL bEndLoading;
-(void)OnRequest;
-(void)stopLoading;//停止加载

@end
