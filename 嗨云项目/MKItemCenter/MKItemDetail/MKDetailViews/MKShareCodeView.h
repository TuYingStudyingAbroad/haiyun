//
//  MKShareCodeView.h
//  嗨云项目
//
//  Created by 李景 on 16/5/21.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKShareCodeView : UIView

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;

@property (weak, nonatomic) IBOutlet UIButton *shareToWeChatBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveInPhoneBtn;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@end
