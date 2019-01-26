//
//  bankDetailViewController.h
//  嗨云项目
//
//  Created by kans on 16/5/10.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bankDetailViewController : UIViewController
//提现编码
@property (nonatomic,copy)NSString * withdrawalsNumber;
//拒绝原因
@property (nonatomic,copy)NSString *refusalReason;
//是否显示完成；
@property (nonatomic,assign) BOOL  showComplete;
@end
