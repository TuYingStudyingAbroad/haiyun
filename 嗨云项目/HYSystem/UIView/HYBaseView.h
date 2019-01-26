//
//  HYBaseView.h
//  HaiYun
//
//  Created by YanLu on 16/3/31.
//  Copyright © 2016年 YanLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYBaseViewDelegate <NSObject>

@optional
-(void)OnPushController:(NSInteger)nMsgType wParam:(id)wParam;
@end

@interface HYBaseView : UIView
{
    BOOL _bShowLoading;//界面是否显示加载
    BOOL _bEndLoading;//加载停止判断
}
@property BOOL bShowLoading;
@property BOOL bEndLoading;

@property (nonatomic, weak) __weak id<HYBaseViewDelegate> baseDelegate;

-(void)OnRequest;

-(void)stopLoading;//停止加载

@end
