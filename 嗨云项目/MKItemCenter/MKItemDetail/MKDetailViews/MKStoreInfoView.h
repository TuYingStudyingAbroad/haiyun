//
//  MKStoreInfoView.h
//  嗨云项目
//
//  Created by 李景 on 16/5/16.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKStoreInfoView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *storeImageView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeSignLabel;
@property (weak, nonatomic) IBOutlet UIButton *clickStoreButton;

@end
