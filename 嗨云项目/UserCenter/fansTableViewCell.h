//
//  fansTableViewCell.h
//  嗨云项目
//
//  Created by 小辉 on 16/8/30.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fansObject.h"
@interface fansTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UIImageView *sexImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (nonatomic,copy)NSString * lastTimeStr;
@property (nonatomic,copy)NSString * nowTimeStr;

@property (nonatomic,strong)fansObject* fansObject;
- (void)layoutCellSubviews;
@end
