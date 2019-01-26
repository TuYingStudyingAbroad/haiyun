//
//  HYSafeBandNumView.h
//  嗨云项目
//
//  Created by YanLu on 16/5/11.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYBaseView.h"

/**
 *  设置密码，修改密码
 */
@interface HYSafeBandNumView : HYBaseView

@property (nonatomic,copy) NSString *nsPhoneNum;
@property (nonatomic,assign) BOOL nsIsCard;
/**
 *  0从来木有绑定过，1旧的手机号码验证，2新的绑定,4别人进来的从来木有显示的
 */
@property (nonatomic,assign) NSInteger  nsPhoneType;


-(void)onButtonClickRight;
@end
