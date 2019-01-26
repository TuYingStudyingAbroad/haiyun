//
//  UIBarButtonItem+HYYL.m
//  嗨云项目
//
//  Created by YanLu on 16/5/12.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "UIBarButtonItem+HYYL.h"

@implementation UIBarButtonItem (HYYL)

- (id)initWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action
{
    // 创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 设置普通背景图片
    UIImage *image = [UIImage imageNamed:icon];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    
    // 设置高亮图片
    [btn setBackgroundImage:[UIImage imageNamed:highlighted] forState:UIControlStateHighlighted];
    
    // 设置尺寸
    btn.bounds = (CGRect){CGPointZero, image.size};
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [self initWithCustomView:btn];
}

+ (id)itemWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action
{
    return [[self alloc] initWithIcon:icon highlightedIcon:highlighted target:target action:action];
}

- (id)initWithMJTitle:(NSString *)title target:(id)target action:(SEL)action
{
    // 创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 设置标题
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:kHEXCOLOR(0x252525) forState:UIControlStateNormal];
    [btn setTitleColor:kHEXCOLOR(0x252525) forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0f]};
    CGSize btnSize = [title sizeWithAttributes:dict];
    btn.bounds = (CGRect){CGPointZero, btnSize};
    return [self initWithCustomView:btn];
}

+ (id)itemWithMJTitle:(NSString *)title target:(id)target action:(SEL)action
{
    return [[self alloc] initWithMJTitle:title target:target action:action];
}

@end
