//
//  HYBaseViewController.m
//  嗨云项目
//
//  Created by haiyun on 16/6/13.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYBaseViewController.h"

@interface HYBaseViewController ()

@end

@implementation HYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.edgesForExtendedLayout= UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    self.view.backgroundColor = kHEXCOLOR(0xf5f5f5);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
