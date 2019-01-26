//
//  incomeListViewController.h
//  嗨云项目
//
//  Created by kans on 16/5/9.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol totopDelegate <NSObject>

- (void)getMoneyViewControllerNeedScrollToTop;

@end

@interface incomeListViewController : UIViewController

@property (nonatomic,assign)NSInteger orderStatus;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, weak) id<totopDelegate> delegate;
@end
