//
//  MKSKUViewController.h
//  YangDongXi
//
//  Created by cocoa on 15/4/28.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKItemSKUObject.h"
#import "MKItemObject.h"


typedef NS_ENUM (NSInteger, MKSKUViewControllerMode)
{
    MKSKUViewControllerModeSubmit,
    MKSKUViewControllerModePurchase
};


@class MKSKUViewController;
@protocol MKSKUViewControllerDelegate <NSObject>

- (void)skuViewControllerDidSubmit:(MKSKUViewController *)viewController;

- (void)skuViewControllerDidPurchase:(MKSKUViewController *)viewController;

- (void)skuViewControllerDidAddToCart:(MKSKUViewController *)viewController;

- (void)skuViewControllerDidClose:(MKSKUViewController *)viewController;

- (void)skuViewControllerViewDidLoad:(MKSKUViewController *)viewController;

@end


@interface MKSKUViewController : UIViewController

@property (nonatomic, assign) NSInteger tag;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *taxestLabel;
@property (weak, nonatomic) IBOutlet UIView *taxestView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *taxViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *stockStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *taxLimitLabel1;
@property (weak, nonatomic) IBOutlet UIButton *taxLimitLabel2;

@property (nonatomic, assign, readonly) BOOL isSoldOut;

@property (nonatomic, assign) MKSKUViewControllerMode mode;

@property (nonatomic, weak) id<MKSKUViewControllerDelegate> delegate;

@property (nonatomic, strong, readonly) NSString *allPriceString;

@property (nonatomic, strong, readonly) NSString *allOriginPriceString;
@property (nonatomic, strong, readonly) NSString *allMinDicountString;


- (void)dismiss:(void (^)(void))completion;

- (void)loadItem:(MKItemObject *)item;

- (NSInteger)getNumber;

- (MKItemSKUObject *)getSelectSKU;

- (NSArray *)getMissSelectionTitles;

- (NSArray *)getPropertyTitles;

- (void)disablePurchaseAndAddCart:(BOOL)disable;

@end
