//
//  getMoneyHeardView.h
//  嗨云项目
//
//  Created by 小辉 on 16/8/29.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface getMoneyHeardView : UIView
//可用余额
@property (weak, nonatomic) IBOutlet UILabel *cUsedLab;
//待确认
@property (weak, nonatomic) IBOutlet UILabel *CnUsedLab;

@property (weak, nonatomic) IBOutlet UILabel *inGetLab;

@property (weak, nonatomic) IBOutlet UILabel *allMoneyLab;
@property (weak, nonatomic) IBOutlet UIButton *tiXianBtn;

@end
