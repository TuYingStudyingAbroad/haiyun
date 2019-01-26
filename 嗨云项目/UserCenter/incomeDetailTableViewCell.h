//
//  incomeDetailTableViewCell.h
//  嗨云项目
//
//  Created by kans on 16/5/9.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXHBalanceObject.h"
@interface incomeDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *statuesLab;
@property (nonatomic,assign)NSInteger status;



@property (nonatomic,strong)WXHBalanceObject * WXHBalanceOBJ;
- (void)layoutCellSubviews;

@end
