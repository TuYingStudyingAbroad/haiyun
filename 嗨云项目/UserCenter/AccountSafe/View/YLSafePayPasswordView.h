//
//  YLSafePayPasswordView.h
//  嗨云项目
//
//  Created by YanLu on 16/5/14.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYBaseView.h"

@interface YLSafePayPasswordView : HYBaseView

-(id)initWithFrame:(CGRect)frame hideForget:(BOOL)isHide;
-(void)safePayPasswordClearAll;
-(void)updateTitleLabel:(NSString *)title;

@end
