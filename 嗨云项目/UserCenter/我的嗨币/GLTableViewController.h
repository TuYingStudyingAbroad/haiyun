//
//  GLTableViewController.h
//  嗨云项目
//
//  Created by 唯我独尊 on 16/8/19.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLObject.h"
@interface GLTableViewController : UITableViewController

@property (nonatomic,strong)GLObject *glo;
//店铺名称
@property (weak, nonatomic) IBOutlet UILabel *dpNamen;
//邀请码
@property (weak, nonatomic) IBOutlet UILabel *yqmL;
//客户等级Label
@property (weak, nonatomic) IBOutlet UILabel *djL;
//客户等级显示图标
@property (weak, nonatomic) IBOutlet UIButton *djB;
//头像背景
@property (weak, nonatomic) IBOutlet UIView *txBackV;
//头像
@property (weak, nonatomic) IBOutlet UIImageView *txIV;
//今日收益
@property (weak, nonatomic) IBOutlet UILabel *jrsrL;
//累计收益
@property (weak, nonatomic) IBOutlet UILabel *ljsyL;

@property (weak, nonatomic) IBOutlet UIView *View7;

@property (weak, nonatomic) IBOutlet UIView *View8;







@end
