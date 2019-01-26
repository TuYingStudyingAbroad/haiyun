//
//  getMoneyTableViewController.h
//  嗨云项目
//
//  Created by kans on 16/5/9.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface getMoneyTableViewController : UITableViewController
//可用余额
@property (weak, nonatomic) IBOutlet UILabel *cUsedLab;
//待确认
@property (weak, nonatomic) IBOutlet UILabel *CnUsedLab;
//累计收益
@property (weak, nonatomic) IBOutlet UILabel *allMoneyLab;

@end
