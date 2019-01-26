//
//  MKDetailBrandZoneView.h
//  YangDongXi
//
//  Created by cocoa on 15/4/27.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKDetailBrandZoneView : UIView
/**
 *  title
 */
@property (nonatomic, strong) IBOutlet UILabel *title;
/**
 *  图片
 */
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
/**
 *  总btn
 */
@property (nonatomic, strong) IBOutlet UIButton *button;
/**
 *  内容
 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
/**
 *  进入btn
 */
@property (weak, nonatomic) IBOutlet UIButton *inButton;

@end
