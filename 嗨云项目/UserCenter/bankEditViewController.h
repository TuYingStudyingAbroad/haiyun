//
//  bankEditViewController.h
//  嗨云项目
//
//  Created by kans on 16/5/12.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKBaseViewController.h"
#import "WXHBankListObject.h"

@protocol bankEditViewControllerDelegate <NSObject> 


-(void)didSuccessAddBank:(WXHBankListObject*)newBank;

@end

@interface bankEditViewController : MKBaseViewController
@property (assign,nonatomic) id <bankEditViewControllerDelegate>delegate;
@end
