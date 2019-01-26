//
//  WXHBankCardViewController.h
//  嗨云项目
//
//  Created by kans on 16/5/12.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WXHBankListObject.h"
@protocol WXHBankCardViewControllerDelegate <NSObject>

-(void)didSelectBank:(WXHBankListObject*)bankListObject;

@end


@interface WXHBankCardViewController : UIViewController
//标记cell是否可选 与提现时选着银行卡有关
@property (assign, nonatomic) BOOL canSelected;
//改变title；
@property (assign,nonatomic)BOOL changeTitle;
@property (weak,nonatomic)id<WXHBankCardViewControllerDelegate>delegate;

@end
