//
//  JoinUSViewController.h
//  嗨云项目
//
//  Created by 小辉 on 16/9/1.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^haiKeBlcok)(NSString * code);

@interface JoinUSViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
@property (weak, nonatomic) IBOutlet UIButton *ruleBtn;
@property (nonatomic,strong) haiKeBlcok haiKeBlock;

@end
