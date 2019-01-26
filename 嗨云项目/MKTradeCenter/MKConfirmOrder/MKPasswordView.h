//
//  MKPasswordView.h
//  嗨云项目
//
//  Created by 杨鑫 on 16/6/3.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKPasswordView : UIView
@property (weak, nonatomic) IBOutlet UIView *backgroundFrame;
@property (strong, nonatomic)UIButton *quXiao;

@property (weak, nonatomic) IBOutlet UIButton *notPassWork;

@property (strong,nonatomic)IBOutletCollection(UILabel) NSMutableArray *passLable;

@end
