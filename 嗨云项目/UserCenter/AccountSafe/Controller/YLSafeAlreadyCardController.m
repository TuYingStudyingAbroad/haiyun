//
//  YLSafeAlreadyCardController.m
//  嗨云项目
//
//  Created by YanLu on 16/5/14.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "YLSafeAlreadyCardController.h"
#import "YLSafeAlreadyView.h"

@interface YLSafeAlreadyCardController ()
{

    YLSafeAlreadyView *_pView;
}


@end

@implementation YLSafeAlreadyCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kHEXCOLOR(0xf5f5f5);
    /**初始化界面**/
    [self initsubView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)initsubView
{
    self.title = @"实名认证";
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    rect.size.height -= rect.origin.y;
    if ( _pView == nil)
    {
        _pView = NewObject(YLSafeAlreadyView);
        _pView.name = self.name;
        _pView.cardId = self.cardId;
        _pView.frame = rect;
        [self.view addSubview:_pView];
    }
    else
    {
        _pView.frame = rect;
    }

}




@end
