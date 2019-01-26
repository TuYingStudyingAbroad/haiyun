//
//  MKStoreNameCell.h
//  嗨云项目
//
//  Created by 李景 on 16/5/11.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKStoreNameCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *selectButton2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectBtnLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectBtnLeading2;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;

//- (void)updateContentWithItem:(MKCartItemObject *)item;
- (void)switchSelectButton:(BOOL)oneToTwo animation:(BOOL)animation;
@end
