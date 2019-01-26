//
//  MKChildHomePageViewController.h
//  嗨云项目
//
//  Created by 杨鑫 on 16/5/18.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKBaseViewController.h"

@interface MKChildHomePageViewController : MKBaseViewController


@property (nonatomic,assign) BOOL isHide;

@property (nonatomic,strong)NSString *state;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
