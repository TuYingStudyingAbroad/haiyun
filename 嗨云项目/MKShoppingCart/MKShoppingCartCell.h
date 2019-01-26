//
//  MKShoppingCartCell.h
//  YangDongXi
//
//  Created by cocoa on 15/4/20.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+MKExtension.h"
#import "MKNumberEditView.h"
#import "MKCartItemObject.h"

@class MKShoppingCartCell;

@protocol MKShoppingCartCellDelegate <NSObject>

@optional
- (void)willBeginEditNumOfItem:(MKCartItemObject *)item;
/**
 *  @param addOrMinus     YES: add   NO: minus
 */
- (void)didChangeCountOfItem:(MKCartItemObject *)item addOrMinus:(BOOL)addOrMinus isSuccess:(BOOL)isSuccess responseObject:(MKCartItemObject *)responseObject;
- (void)didConfirmToDeleteShoppingCartItem:(MKCartItemObject *)item cell:(MKShoppingCartCell *)cell;
/**
 *  折叠或者展开cell
 *
 *  @param collapseOrExpand YES：展开  NO：折叠
 *  @param cell
 */

- (void)didClickSelectSingleButton:(BOOL)IsSelected;

@end

@interface MKShoppingCartCell : UITableViewCell

@property (weak, nonatomic) id<MKShoppingCartCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *limitLabel;

@property (weak, nonatomic) IBOutlet UILabel *skuLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusDetailLabel;

@property (nonatomic,strong)MKCartItemObject *itme;

@property (assign, nonatomic) BOOL canEditQuantity;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *cellSelectedBtn;

@property (weak, nonatomic) IBOutlet UIButton *selectButton2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numSpace;

@property (nonatomic, strong) IBOutlet MKNumberEditView *numberEditView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numViewWidth;

+ (NSString *)reuseIdentifier;

- (void)updateContentWithItem:(MKCartItemObject *)item;

- (void)switchSelectButton:(BOOL)oneToTwo animation:(BOOL)animation;

@end
